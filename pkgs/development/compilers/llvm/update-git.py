#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 nix

import csv
import fileinput
import json
import os
import re
import subprocess
import sys

from codecs import iterdecode
from datetime import datetime
from urllib.request import urlopen, Request


DEFAULT_NIX = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'default.nix')


def get_latest_chromium_build():
    RELEASES_URL = 'https://versionhistory.googleapis.com/v1/chrome/platforms/linux/channels/dev/versions/all/releases?filter=endtime=none&order_by=version%20desc'
    print(f'GET {RELEASES_URL}')
    with urlopen(RELEASES_URL) as resp:
        return json.load(resp)['releases'][0]


def get_file_revision(revision, file_path):
    """Fetches the requested Git revision of the given Chromium file."""
    url = f'https://raw.githubusercontent.com/chromium/chromium/{revision}/{file_path}'
    with urlopen(url) as http_response:
        return http_response.read().decode()


def get_commit(ref):
    url = f'https://api.github.com/repos/llvm/llvm-project/commits/{ref}'
    headers = {'Accept': 'application/vnd.github.v3+json'}
    request = Request(url, headers=headers)
    with urlopen(request) as http_response:
        return json.loads(http_response.read().decode())


def get_current_revision():
    """Get the current revision of llvmPackages_git."""
    with open(DEFAULT_NIX) as f:
        for line in f:
            rev = re.search(r'^      rev = "(.*)";', line)
            if rev:
                return rev.group(1)
    sys.exit(1)


def nix_prefetch_url(url, algo='sha256'):
    """Prefetches the content of the given URL."""
    print(f'nix-prefetch-url {url}')
    out = subprocess.check_output(['nix-prefetch-url', '--type', algo, '--unpack', url])
    return out.decode('utf-8').rstrip()


chromium_build = get_latest_chromium_build()
chromium_version = chromium_build['version']
print(f'chromiumDev version: {chromium_version}')
print('Getting LLVM commit...')
clang_update_script = get_file_revision(chromium_version, 'tools/clang/scripts/update.py')
clang_revision = re.search(r"^CLANG_REVISION = '(.+)'$", clang_update_script, re.MULTILINE).group(1)
clang_commit_short = re.search(r"llvmorg-[0-9]+-init-[0-9]+-g([0-9a-f]{8})", clang_revision).group(1)
release_version = re.search(r"^RELEASE_VERSION = '(.+)'$", clang_update_script, re.MULTILINE).group(1)
commit = get_commit(clang_commit_short)
if get_current_revision() == commit["sha"]:
    print('No new update available.')
    sys.exit(0)
date = datetime.fromisoformat(commit['commit']['committer']['date'].rstrip('Z')).date().isoformat()
version = f'unstable-{date}'
print('Prefetching source tarball...')
hash = nix_prefetch_url(f'https://github.com/llvm/llvm-project/archive/{commit["sha"]}.tar.gz')
print('Updating default.nix...')
with fileinput.FileInput(DEFAULT_NIX, inplace=True) as f:
    for line in f:
        if match := re.search(r'^      rev-version = "unstable-(.+)";', line):
                old_date = match.group(1)
        result = line
        result = re.sub(r'^      version = ".+";', f'    version = "{release_version}";', result)
        result = re.sub(r'^      rev = ".*";', f'      rev = "{commit["sha"]}";', result)
        result = re.sub(r'^      rev-version = ".+";', f'      rev-version = "{version}";', result)
        result = re.sub(r'^      sha256 = ".+";', f'      sha256 = "{hash}";', result)
        print(result, end='')
# Commit the result:
commit_message = f"llvmPackages_git: {old_date} -> {date}"
subprocess.run(['git', 'add', DEFAULT_NIX], check=True)
subprocess.run(['git', 'commit', '--file=-'], input=commit_message.encode(), check=True)
