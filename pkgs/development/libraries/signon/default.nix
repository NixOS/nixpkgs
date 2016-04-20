{ stdenv, fetchurl, doxygen, qtbase, qmakeHook }:

stdenv.mkDerivation rec {
  name = "signon-${version}";
  version = "8.57";
  src = fetchurl {
    url = "https://gitlab.com/accounts-sso/signond/repository/archive.tar.gz?ref=${version}";
    sha256 = "1vqkxhmdjk3217k38l2s3wld8x7f4jrbbh6xbr036cn1r23ncni5";
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ doxygen qmakeHook ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake/SignOnQt5"
  '';

}
