{fetchurl, perl, db4}:

import ../generic perl {
  name = "BerkeleyDB-0.26";
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/CPAN/authors/id/P/PM/PMQS/BerkeleyDB-0.26.tar.gz;
    md5 = "6e9882f4e4bac48b24079d082af30e6c";
  };
  perlPreHook = ./hook.sh;
  inherit db4;
}
