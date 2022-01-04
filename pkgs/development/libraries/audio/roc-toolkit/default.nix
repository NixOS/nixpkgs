{ stdenv,
  lib,
  fetchFromGitHub,
  sconsPackages,
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
    sconsPackages.scons_3_0_1
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
    [ "--disable-sox"
      "--disable-tests" ] ++
    lib.optional (!libunwindSupport) "--disable-libunwind" ++
    lib.optional (!pulseaudioSupport) "--disable-pulseaudio" ++
    (if (!openfecSupport)
       then ["--disable-openfec"]
       else [ "--with-libraries=${openfec}/lib"
              "--with-openfec-includes=${openfec.dev}/include" ]);

  preConfigure = ''
    sconsFlags+=" --prefix=$out"
  '';

  meta = with lib; {
    description = "Roc is a toolkit for real-time audio streaming over the network";
    homepage = "https://github.com/roc-streaming/roc-toolkit";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bgamari ];
    platforms = platforms.unix;
  };
}
