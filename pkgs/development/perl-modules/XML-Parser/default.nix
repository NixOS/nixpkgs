{fetchurl, perl, expat}:

import ../generic perl {
  name = "XML-Parser-2.36";
  src = fetchurl {
    url = mirror://cpan/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz;
    sha256 = "0gyp5qfbflhkin1zv8l6wlkjwfjvsf45a3py4vc6ni82fj32kmcz";
  };
  makeMakerFlags = "EXPATLIBPATH=${expat}/lib EXPATINCPATH=${expat}/include";
}
