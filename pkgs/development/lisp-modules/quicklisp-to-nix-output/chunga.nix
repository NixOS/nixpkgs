args @ { fetchurl, ... }:
rec {
  baseName = ''chunga'';
  version = ''1.1.6'';

  description = '''';

  deps = [ args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/chunga/2014-12-17/chunga-1.1.6.tgz'';
    sha256 = ''1ivdfi9hjkzp2anhpjm58gzrjpn6mdsp35km115c1j1c4yhs9lzg'';
  };

  overrides = x: {
  };
}
