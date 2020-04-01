{ stdenv, fetchFromGitHub, cmake, pkgconfig
, curl, libxml2, pam, sblim-sfcc }:

stdenv.mkDerivation rec {
  pname = "openwsman";
  version = "2.6.11";

  src = fetchFromGitHub {
    owner  = "Openwsman";
    repo   = "openwsman";
    rev    = "v${version}";
    sha256 = "0s8xdxrxnh1l0v41n5cw89b89rrlqlxn1yj14sw224230y8m70ka";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ curl libxml2 pam sblim-sfcc ];

  cmakeFlags = [
    "-DCMAKE_BUILD_RUBY_GEM=no"
    "-DBUILD_PYTHON=no"
    "-DBUILD_PYTHON3=yes"
  ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DPACKAGE_ARCHITECTURE=$(uname -m)";
  '';

  configureFlags = [ "--disable-more-warnings" ];

  meta = with stdenv.lib; {
    description  = "Openwsman server implementation and client API with bindings";
    downloadPage = https://github.com/Openwsman/openwsman/releases;
    homepage     = https://openwsman.github.io;
    license      = licenses.bsd3;
    maintainers  = with maintainers; [ deepfire ];
    platforms    = platforms.linux; # PAM is not available on Darwin
    inherit version;
  };
}
