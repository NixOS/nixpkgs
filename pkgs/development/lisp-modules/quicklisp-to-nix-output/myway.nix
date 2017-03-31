args @ { fetchurl, ... }:
rec {
  baseName = ''myway'';
  version = ''20150302-git'';

  description = ''Sinatra-compatible routing library.'';

  deps = [ args."alexandria" args."cl-ppcre" args."cl-utilities" args."map-set" args."quri" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/myway/2015-03-02/myway-20150302-git.tgz'';
    sha256 = ''1spab9zzhwjg3r5xncr5ncha7phw72wp49cxxncgphh1lfaiyblh'';
  };

  overrides = x: {
  };
}
