{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.41";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.xz";
    sha256 = "1fldlsw51al9cvmz8dixrfv2j80bamjd5bzxsa66cvhc48n8p2nf";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
  };
}
