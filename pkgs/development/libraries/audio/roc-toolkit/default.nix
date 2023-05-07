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
  libpulseaudio,
  opensslSupport ? true,
  openssl,
  soxSupport ? true,
  sox
}:

stdenv.mkDerivation rec {
  pname = "roc-toolkit";
  version = "0.2.3";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "roc-streaming";
    repo = "roc-toolkit";
    rev = "v${version}";
    hash = "sha256-wwcc2r1hrM9zryMJp+DOifSh0g6T/gdZJMpVdhqhjR8=";
  };

  nativeBuildInputs = [
    scons
    ragel
    gengetopt
    pkg-config
  ];

  propagatedBuildInputs = [
    libuv
    speexdsp
  ] ++ lib.optional openfecSupport openfec
    ++ lib.optional libunwindSupport libunwind
    ++ lib.optional pulseaudioSupport libpulseaudio
    ++ lib.optional opensslSupport openssl
    ++ lib.optional soxSupport sox;

  sconsFlags =
    [ "--build=${stdenv.buildPlatform.config}"
      "--host=${stdenv.hostPlatform.config}"
      "--prefix=${placeholder "out"}" ] ++
    lib.optional (!opensslSupport) "--disable-openssl" ++
    lib.optional (!soxSupport) "--disable-sox" ++
    lib.optional (!libunwindSupport) "--disable-libunwind" ++
    lib.optional (!pulseaudioSupport) "--disable-pulseaudio" ++
    (if (!openfecSupport)
       then ["--disable-openfec"]
       else [ "--with-libraries=${openfec}/lib"
              "--with-openfec-includes=${openfec.dev}/include" ]);

  meta = with lib; {
    description = "Roc is a toolkit for real-time audio streaming over the network";
    homepage = "https://github.com/roc-streaming/roc-toolkit";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.unix;
  };
}
