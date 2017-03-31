args @ { fetchurl, ... }:
rec {
  baseName = ''xmls'';
  version = ''1.7'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/xmls/2015-04-07/xmls-1.7.tgz'';
    sha256 = ''1pch221g5jv02rb21ly9ik4cmbzv8ca6bnyrs4s0yfrrq0ji406b'';
  };

  overrides = x: {
  };
}
