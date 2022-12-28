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
  libunwindSupport ? true,
  libunwind,
  pulseaudioSupport ? true,
  libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "roc-toolkit";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "roc-streaming";
    repo = "roc-toolkit";
    rev = "v${version}";
    sha256 = "sha256:1pld340zfch4p3qaf5anrspq7vmxrgf9ddsdsq92pk49axaaz19w";
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
  ];

  sconsFlags =
    [ "--build=${stdenv.buildPlatform.config}"
      "--host=${stdenv.hostPlatform.config}"
      "--prefix=${placeholder "out"}"
      "--disable-sox"
      "--disable-doc"
      "--disable-tests" ] ++
    lib.optional (!libunwindSupport) "--disable-libunwind" ++
    lib.optional (!pulseaudioSupport) "--disable-pulseaudio" ++
    (if (!openfecSupport)
       then ["--disable-openfec"]
       else [ "--with-libraries=${openfec}/lib"
              "--with-openfec-includes=${openfec.dev}/include" ]);

  prePatch = lib.optionalString stdenv.isAarch64
    "sed -i 's/c++98/c++11/g' SConstruct";

  # TODO: Remove these patches in the next version.
  patches = [
    ./0001-Remove-deprecated-scons-call.patch
    ./0002-Fix-compatibility-with-new-SCons.patch
  ];

  meta = with lib; {
    description = "Roc is a toolkit for real-time audio streaming over the network";
    homepage = "https://github.com/roc-streaming/roc-toolkit";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.unix;
  };
}
