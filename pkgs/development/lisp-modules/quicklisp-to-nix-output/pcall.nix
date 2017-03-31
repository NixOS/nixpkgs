args @ { fetchurl, ... }:
rec {
  baseName = ''pcall'';
  version = ''0.3'';

  description = '''';

  deps = [ args."bordeaux-threads" args."pcall-queue" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/pcall/2010-10-06/pcall-0.3.tgz'';
    sha256 = ''02idx1wnv9770fl2nh179sb8njw801g70b5mf8jqhqm2gwsb731y'';
  };

  overrides = x: {
  };
}
