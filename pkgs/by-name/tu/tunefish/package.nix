{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  alsa-lib,
  curl,
  freetype,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tunefish";
  version = "0-unstable-2021-12-19";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "tunefish";
    rev = "c801c6cab63bb9e78e38ed69bd92024f2c667f00";
    hash = "sha256-ZH2VD0IydEFdbB3Ht5D6/lbcWLQHBuu9GyasVP7VefI=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    alsa-lib
    curl
    freetype
    libGL
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  makeFlags = [
    "-C"
    "src/tunefish4/Builds/LinuxMakefile"
    "CONFIG=Release"
  ];

  # silences build warnings
  HOME = "/build";

  postPatch = ''
    patchShebangs src/tunefish4/generate-lv2-ttl.py
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/{lv2,vst,vst3}

    pushd src/tunefish4/Builds/LinuxMakefile/build
    cp -r "Tunefish4.lv2" $out/lib/lv2
    cp -r "Tunefish4.vst3" $out/lib/vst3
    cp "Tunefish4.so" $out/lib/vst
    popd

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://tunefish-synth.com/";
    description = "Virtual analog synthesizer LV2 plugin";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ orivej ];
    platforms = [ "x86_64-linux" ];
  };
})
