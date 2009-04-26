{fetchurl, perl}:

import ../generic perl {
  name = "perl-Font-TTF-0.43";
  src = fetchurl {
    url = mirror://cpan/authors/id/M/MH/MHOSKEN/Font-TTF-0.43.tar.gz;
    sha256 = "0782mj5n5a2qbghvvr20x51llizly6q5smak98kzhgq9a7q3fg89";
  };
  perlPreHook = "makeMakerFlags=\"EXPATLIBPATH=$expat/lib EXPATINCPATH=$expat/include\"";
}
