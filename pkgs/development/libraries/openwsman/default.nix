{ stdenv, fetchFromGitHub, cmake, pkgconfig
, curl, libxml2, pam, sblim-sfcc }:

stdenv.mkDerivation rec {
  name = "openwsman-${version}";
  version = "2.6.5";

  src = fetchFromGitHub {
    owner  = "Openwsman";
    repo   = "openwsman";
    rev    = "v${version}";
    sha256 = "1r0zslgpcr4m20car4s3hsccy10xcb39qhpw3dhpjv42xsvvs5xv";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ curl libxml2 pam sblim-sfcc ];

  cmakeFlags = [
    "-DCMAKE_BUILD_RUBY_GEM=no"
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
