{
  lib,
  stdenv,
  fetchFromGitHub,
  fpc,
  openssl,
}:

let
  flreSrc = fetchFromGitHub {
    owner = "benibela";
    repo = "flre";
    rev = "3e926d45d4352f1b7c7cd411ccd625df117dad5c";
    hash = "sha256-fs7CIjd3fwD/SORYh5pmJxIdrr8F9e36TNmnKUbUxP0=";
  };
  synapseSrc = fetchFromGitHub {
    owner = "benibela";
    repo = "ararat-synapse";
    rev = "7a77db926de66809080bada68b54172da7f84c0e";
    hash = "sha256-bVLQ0ohGJYtuP88Krxy9a7RnHHrW0OWw8H/uxa3PerU=";
  };
  rcmdlineSrc = fetchFromGitHub {
    owner = "benibela";
    repo = "rcmdline";
    rev = "ea02b770c4568717dd7b3b72da191a8bbcb4c751";
    hash = "sha256-6YtvAf0joRvtCKbUAaLwuwABw1GEIzammFLhboq9aG0=";
  };
  internettoolsSrc = fetchFromGitHub {
    owner = "benibela";
    repo = "internettools";
    rev = "dd972caaa4415468fa679ea7262976ead3fd3e38";
    hash = "sha256-09sADxPiE6ky1EX7dTXRBYVT3IarUcLYf5knzi7+CHU=";
  };
  pasdblstrutilsSrc = fetchFromGitHub {
    owner = "BeRo1985";
    repo = "pasdblstrutils";
    rev = "1696f0a2b822fef26c8992f96620f1be129cfa99";
    hash = "sha256-x0AjOTa1g7gJOR2iBO76yBt1kzcRNujHRUsq5QOlfP0=";
  };
in
stdenv.mkDerivation rec {
  pname = "xidel";
  version = "unstable-2022-11-01";

  src = fetchFromGitHub {
    owner = "benibela";
    repo = pname;
    rev = "6d5655c1d73b88ddeb32d2450a35ee36e4762bb8";
    hash = "sha256-9x2d5AKRBjocRawRHdeI4heIM5nb00/F/EIj+/to7ac=";
  };

  nativeBuildInputs = [ fpc ];
  buildInputs = [ openssl ];

  NIX_LDFLAGS = [ "-lcrypto" ];

  patchPhase = ''
    patchShebangs \
      build.sh \
      tests/test.sh \
      tests/tests-file-module.sh \
      tests/tests.sh \
      tests/downloadTest.sh \
      tests/downloadTests.sh \
      tests/zorbajsoniq.sh \
      tests/zorbajsoniq/download.sh
  '';

  preBuildPhase = ''
    mkdir -p import/{flre,synapse,pasdblstrutils} rcmdline internettools
    cp -R ${flreSrc}/. import/flre
    cp -R ${pasdblstrutilsSrc}/. import/pasdblstrutils
    cp -R ${rcmdlineSrc}/. rcmdline
    cp -R ${internettoolsSrc}/. internettools

    cp -R ${synapseSrc}/. import/synapse
    substituteInPlace import/synapse/ssl_openssl{,11}_lib.pas \
      --replace-fail 'libcrypto.dylib' '${lib.getLib openssl}/lib/libcrypto.dylib' \
      --replace-fail 'libssl.dylib' '${lib.getLib openssl}/lib/libssl.dylib'
  '';

  buildPhase = ''
    runHook preBuildPhase
    ./build.sh
    runHook postBuildPhase
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/man/man1"
    cp meta/xidel.1 "$out/share/man/man1/"
    cp xidel "$out/bin/"
  '';

  # disabled, because tests require network
  checkPhase = ''
    ./tests/tests.sh
  '';

  meta = with lib; {
    description = "Command line tool to download and extract data from HTML/XML pages as well as JSON APIs";
    mainProgram = "xidel";
    homepage = "https://www.videlibri.de/xidel.html";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
