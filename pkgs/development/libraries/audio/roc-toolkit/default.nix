{ stdenv,
  lib,
  fetchFromGitHub,
  scons,
  ragel,
  gengetopt,
  pkg-config,
  libuv,
  openfecSupport ? true,
  openfec,
  speexdsp,
  libunwindSupport ? true,
  libunwind,
  pulseaudioSupport ? true,
  libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "roc-toolkit";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "roc-streaming";
    repo = "roc-toolkit";
    rev = "v${version}";
    sha256 = "sha256-W8PiI5W1T6pNaYzR4u6fPtkP8DKq/Z85Kq/WF5dXVxo=";
  };

  nativeBuildInputs = [
    scons
    ragel
    gengetopt
    pkg-config
  ];

  buildInputs = [
    libuv
    libunwind
    openfec
    libpulseaudio
    speexdsp
  ];

  sconsFlags =
    [ "--build=${stdenv.buildPlatform.config}"
      "--host=${stdenv.hostPlatform.config}"
      "--prefix=${placeholder "out"}"
      "--disable-sox" ] ++
    lib.optional (!libunwindSupport) "--disable-libunwind" ++
    lib.optional (!pulseaudioSupport) "--disable-pulseaudio" ++
    (if (!openfecSupport)
       then ["--disable-openfec"]
       else [ "--with-libraries=${openfec}/lib"
              "--with-openfec-includes=${openfec.dev}/include" ]);

  prePatch = lib.optionalString stdenv.isAarch64
    "sed -i 's/c++98/c++11/g' SConstruct";

  patches = [
    ./fix-pkgconfig-installation.patch
  ];

  meta = with lib; {
    description = "Roc is a toolkit for real-time audio streaming over the network";
    homepage = "https://github.com/roc-streaming/roc-toolkit";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.unix;
  };
}
