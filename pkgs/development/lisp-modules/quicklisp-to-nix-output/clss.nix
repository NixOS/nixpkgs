args @ { fetchurl, ... }:
rec {
  baseName = ''clss'';
  version = ''20170124-git'';

  description = ''A DOM tree searching engine based on CSS selectors.'';

  deps = [ args."array-utils" args."plump" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/clss/2017-01-24/clss-20170124-git.tgz'';
    sha256 = ''0rrg3brzash1b14n686xjx6d5glm2vg32g0i8hyvaffqd82493pb'';
  };

  overrides = x: {
  };
}
