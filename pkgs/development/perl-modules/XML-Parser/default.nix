{fetchurl, perl, expat}:

import ../generic perl {
  name = "XML-Parser-2.34";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/XML-Parser-2.34.tar.gz;
    md5 = "84d9e0001fe01c14867256c3fe115899";
  };
  perlPreHook = ./hook.sh;
  inherit expat;
}
