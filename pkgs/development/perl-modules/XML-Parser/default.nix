{fetchurl, perl, expat}:

import ../generic perl {
  name = "XML-Parser-2.34";
  src = fetchurl {
    url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Parser-2.34.tar.gz;
    md5 = "84d9e0001fe01c14867256c3fe115899";
  };
  perlPreHook = "makeMakerFlags=\"EXPATLIBPATH=$expat/lib EXPATINCPATH=$expat/include\"";
  inherit expat;
}
