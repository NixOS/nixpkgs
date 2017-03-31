args @ { fetchurl, ... }:
rec {
  baseName = ''usocket'';
  version = ''0.7.0.1'';

  description = ''Universal socket library for Common Lisp'';

  deps = [ args."split-sequence" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/usocket/2016-10-31/usocket-0.7.0.1.tgz'';
    sha256 = ''1mpcfawbzd72cd841bb0hmgx4kinnvcnazc7vym83gv5iy6lwif2'';
  };

  overrides = x: {
  };
}
