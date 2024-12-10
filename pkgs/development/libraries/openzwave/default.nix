{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  doxygen,
  fontconfig,
  graphviz-nox,
  libxml2,
  pkg-config,
  which,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "openzwave";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "OpenZWave";
    repo = "open-zwave";
    rev = "v${version}";
    sha256 = "0xgs4mmr0480c269wx9xkk67ikjzxkh8xcssrdx0f5xcl1lyd333";
  };

  patches = [
    (fetchpatch {
      name = "fix-strncat-build-failure.patch";
      url = "https://github.com/OpenZWave/open-zwave/commit/601e5fb16232a7984885e67fdddaf5b9c9dd8105.patch";
      sha256 = "1n1k5arwk1dyc12xz6xl4n8yw28vghzhv27j65z1nca4zqsxgza1";
    })
    (fetchpatch {
      name = "fix-text-uninitialized.patch";
      url = "https://github.com/OpenZWave/open-zwave/commit/3b029a467e83bc7f0054e4dbba1e77e6eac7bc7f.patch";
      sha256 = "183mrzjh1zx2b2wzkj4jisiw8br7g7bbs167afls4li0fm01d638";
    })
  ];

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    doxygen
    fontconfig
    graphviz-nox
    libxml2
    pkg-config
    which
  ];

  buildInputs = [ systemd ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";
  FONTCONFIG_PATH = "${fontconfig.out}/etc/fonts/";

  postPatch = ''
    substituteInPlace cpp/src/Options.cpp \
      --replace /etc/openzwave $out/etc/openzwave
  '';

  meta = with lib; {
    description = "C++ library to control Z-Wave Networks via a USB Z-Wave Controller";
    homepage = "http://www.openzwave.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
