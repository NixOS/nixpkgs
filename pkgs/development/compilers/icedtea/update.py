#!/usr/bin/env python3

import subprocess, urllib.request, re, os, tarfile
from html.parser import HTMLParser

HG_URL = 'http://icedtea.classpath.org/hg/release/icedtea{}-forest-{}'
DOWNLOAD_URL = 'http://icedtea.wildebeest.org/download/source/'
DOWNLOAD_HTML = DOWNLOAD_URL + '?C=M;O=D'

ICEDTEA_JDKS = [7]

BUNDLES = ['openjdk', 'corba', 'jaxp', 'jaxws', 'jdk', 'langtools', 'hotspot']

SRC_PATH = './sources.nix'

def get_output(cmd, env = None):
	try:
		proc = subprocess.Popen(cmd, env = env, stdout = subprocess.PIPE)
		out = proc.communicate()[0]
	except subprocess.CalledProcessError as e:
		return None

	return out.decode('utf-8').strip()

def nix_prefetch_url(url):
	env = os.environ.copy()
	env['PRINT_PATH'] = '1'
	out = get_output(['nix-prefetch-url', url], env = env)

	return out.split('\n')

def get_nix_attr(path, attr):
	out = get_output(['nix-instantiate', '--eval-only', '-A', attr, path])

	if len(out) < 2 or out[0] != '"' or out[-1] != '"':
		raise Exception('Cannot find Nix attribute "{}" (parsing failure?)'.format(attr))

	# Strip quotes
	return out[1:-1]

def get_jdk_attr(jdk, attr):
	return get_nix_attr(SRC_PATH, 'icedtea{}.{}'.format(jdk, attr))

class Parser(HTMLParser):
	def __init__(self, link_regex):
		HTMLParser.__init__(self)

		self.regex = link_regex
		self.href = None
		self.version = None

	def handle_starttag(self, tag, attrs):
		if self.href != None or tag != 'a':
			return

		href = None
		for attr in attrs:
			if attr[0] == 'href':
				href = attr[1]
		if href == None:
			return

		m = re.match(self.regex, href)
		if m != None:
			self.href = href
			self.version = m.group(1)

def get_latest_version_url(major):
	f = urllib.request.urlopen(DOWNLOAD_HTML)
	html = f.read().decode('utf-8')
	f.close()

	parser = Parser(r'^icedtea\d?-({}\.\d[\d.]*)\.tar\.xz$'.format(major))
	parser.feed(html)
	parser.close()

	if parser.href == None:
		raise Exception('Error: could not find download url for major version "{}"'.format(major))

	return parser.version, DOWNLOAD_URL + parser.href

def get_old_bundle_attrs(jdk, bundle):
	attrs = {}
	for attr in ('changeset', 'url', 'sha256'):
		attrs[attr] = get_jdk_attr(jdk, 'bundles.{}.{}'.format(bundle, attr))

	return attrs

def get_old_attrs(jdk):
	attrs = {}

	for attr in ('branch', 'version', 'url', 'sha256'):
		attrs[attr] = get_jdk_attr(jdk, attr)

	attrs['bundles'] = {}

	for bundle in BUNDLES:
		attrs['bundles'][bundle] = get_old_bundle_attrs(jdk, bundle)

	return attrs

def get_member_filename(tarball, name):
	for fname in tarball.getnames():
		m = re.match(r'^icedtea\d?-\d[\d.]*/{}$'.format(name), fname)
		if m != None:
			return m.group(0)

	return None

def get_member_file(tarball, name):
	path = get_member_filename(tarball, name)
	if path == None:
		raise Exception('Could not find "{}" inside tarball'.format(name))

	f = tarball.extractfile(path)
	data = f.read().decode('utf-8')
	f.close()

	return data

def get_new_bundle_attr(makefile, bundle, attr):
	var = '{}_{}'.format(bundle.upper(), attr.upper())
	regex = r'^{} = (.*?)$'.format(var)

	m = re.search(regex, makefile, re.MULTILINE)
	if m == None:
		raise Exception('Could not find variable "{}" in Makefile.am'.format(var))

	return m.group(1)

def get_new_bundle_attrs(jdk, branch, path):
	hg_url = HG_URL.format(jdk, branch)

	attrs = {}

	print('Opening file: "{}"'.format(path))
	tar = tarfile.open(name = path, mode = 'r:xz')

	makefile = get_member_file(tar, 'Makefile.am')
	hotspot_map = get_member_file(tar, 'hotspot.map')

	for bundle in BUNDLES:
		battrs = {}

		if bundle == 'hotspot':
			m = re.search(r'^default (.*?) (.*?) (.*?)$', hotspot_map, re.MULTILINE)
			if m == None:
				raise Exception('Could not find info for hotspot bundle in hotspot.map')

			battrs['url'] = '{}/archive/{}.tar.gz'.format(m.group(1), m.group(2))
			battrs['changeset'] = m.group(2)
			battrs['sha256'] = m.group(3)

			attrs[bundle] = battrs
			continue

		changeset = get_new_bundle_attr(makefile, bundle, 'changeset')
		battrs['changeset'] = changeset
		battrs['sha256'] = get_new_bundle_attr(makefile, bundle, 'sha256sum')

		if bundle == 'openjdk':
			battrs['url'] = '{}/archive/{}.tar.gz'.format(hg_url, changeset)
		else:
			battrs['url'] = '{}/{}/archive/{}.tar.gz'.format(hg_url, bundle, changeset)

		attrs[bundle] = battrs

	tar.close()

	return attrs

def get_new_attrs(jdk):
	print('Getting old attributes for JDK {}...'.format(jdk))
	old_attrs = get_old_attrs(jdk)
	attrs = {}

	# The major version corresponds to a specific JDK (1 = OpenJDK6, 2 = OpenJDK7, 3 = OpenJDK8)
	major = jdk - 5

	print('Getting latest version for JDK {}...'.format(jdk))
	version, url = get_latest_version_url(major)

	print()
	print('Old version: {}'.format(old_attrs['version']))
	print('New version: {}'.format(version))
	print()

	if version == old_attrs['version']:
		print('No update available, skipping...')
		print()
		return old_attrs

	print('Update available, generating new attributes for JDK {}...'.format(jdk))

	attrs['version'] = version
	attrs['branch'] = '.'.join(version.split('.')[:2])
	attrs['url'] = url

	print('Downloading tarball from url "{}"...'.format(url))
	print()
	attrs['sha256'], path = nix_prefetch_url(url)
	print()

	print('Inspecting tarball for bundle information...')

	attrs['bundles'] = get_new_bundle_attrs(jdk, attrs['branch'], path)

	print('Done!')

	return attrs

def generate_jdk(jdk):
	attrs = get_new_attrs(jdk)

	branch = attrs['branch']
	src_version = attrs['version'].replace(branch, '${branch}')
	src_url = attrs['url'].replace(attrs['version'], '${version}')

	hg_url = HG_URL.format(jdk, branch)
	src_hg_url = HG_URL.format(jdk, '${branch}')

	src =  '  icedtea{} = rec {{\n'.format(jdk)
	src += '    branch = "{}";\n'.format(branch)
	src += '    version = "{}";\n'.format(src_version)
	src += '\n'
	src += '    url = "{}";\n'.format(src_url)
	src += '    sha256 = "{}";\n'.format(attrs['sha256'])
	src += '\n'
	src += '    hg_url = "{}";\n'.format(src_hg_url)
	src += '\n'
	src += '    bundles = {\n'

	for bundle in BUNDLES:
		battrs = attrs['bundles'][bundle]

		b_url = battrs['url']
		b_url = b_url.replace(hg_url, '${hg_url}')
		b_url = b_url.replace(battrs['changeset'], '${changeset}')

		src += '      {} = rec {{\n'.format(bundle)
		src += '        changeset = "{}";\n'.format(battrs['changeset'])
		src += '        url = "{}";\n'.format(b_url)
		src += '        sha256 = "{}";\n'.format(battrs['sha256'])
		src += '      };\n'

		if bundle != BUNDLES[-1]:
			src += '\n'

	src += '    };\n'
	src += '  };\n'

	return src

def generate_sources(jdks):
	src = '# This file is autogenerated from update.py in the same directory.\n'
	src += '{\n'

	for jdk in jdks:
		print()
		print('Generating sources for JDK {}...'.format(jdk))
		src += generate_jdk(jdk)

	src += '}\n'
	return src

if __name__ == '__main__':
	print('Generating {}...'.format(SRC_PATH))
	src = generate_sources(ICEDTEA_JDKS)

	f = open(SRC_PATH, 'w', encoding = 'utf-8')
	f.write(src)
	f.close()

	print()
	print('Update complete!')
