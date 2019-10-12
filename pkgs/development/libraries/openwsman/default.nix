{ stdenv, fetchFromGitHub, cmake, pkgconfig
, curl, libxml2, pam, sblim-sfcc }:

stdenv.mkDerivation rec {
  pname = "openwsman";
  version = "2.6.9";

  src = fetchFromGitHub {
    owner  = "Openwsman";
    repo   = "openwsman";
    rev    = "v${version}";
    sha256 = "19s5h551ppxmi2kljf8z58jjc6yrpczbxdrl4hh2l4jxv7iphk5i";
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
