{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, curl, libxml2, pam, sblim-sfcc }:

stdenv.mkDerivation rec {
  pname = "openwsman";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner  = "Openwsman";
    repo   = "openwsman";
    rev    = "v${version}";
    sha256 = "sha256-/fSVzpGPObMkJIu7j6eR6A7Gtf2jttoPhcSayBvn3IU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

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

  meta = with lib; {
    description  = "Openwsman server implementation and client API with bindings";
    downloadPage = "https://github.com/Openwsman/openwsman/releases";
    homepage     = "https://openwsman.github.io";
    license      = licenses.bsd3;
    maintainers  = with maintainers; [ deepfire ];
    platforms    = platforms.linux; # PAM is not available on Darwin
  };
}
