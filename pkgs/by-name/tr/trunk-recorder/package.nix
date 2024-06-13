{ lib
, stdenv
, fetchurl
, readline
, termcap
, gnucap
, callPackage
, writeScript
, fetchFromGitHub
, cmake
, pkg-config
, makeWrapper
, gnuradio
, gnupg
, libsndfile
, fftw
, cacert
, gnuradioPackages
, uhd
, boost
, curl
, gmp
, hackrf
, orc
, xorg
, openssl
, libusb1
, git
, spdlog
, volk
, sox
, fdk-aac-encoder
}:
stdenv.mkDerivation rec {
  pname = "trunk-recorder";
  version = "4.7.1";
  src = fetchFromGitHub {
    owner = "robotastic";
    repo = "trunk-recorder";
    rev = "v${version}";
    sha256 = "sha256-nL59+BAL5zKoAZs+i947Zzmj7U0UNsbmMCLnpTLaMQA=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];
  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DSPDLOG_FMT_EXTERNAL=ON"
  ];
  buildInputs = [
    gnuradio
    gnupg
    libsndfile
    fftw
    cacert
    gnuradioPackages.osmosdr
    uhd
    boost
    curl
    gmp
    hackrf
    orc
    xorg.libpthreadstubs
    openssl
    libusb1
    git
    spdlog
    volk
  ];
  postInstall = ''
    wrapProgram $out/bin/trunk-recorder \
       --prefix PATH : ${lib.makeBinPath [ sox fdk-aac-encoder ]}
  '';
  meta = with lib; {
    description = "Record calls on trunked and conventional radio systems";
    longDescription = ''
      Radio call recording supporting trunked P25 & SmartNet systems, conventional P25 & analog systems, and P25 Phase 1, P25 Phase 2 & analog voice channels'';
    homepage = "https://github.com/robotastic/trunk-recorder";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mcdonc ];
    platforms = platforms.linux;
    mainProgram = "trunk-recorder";
  };

}
