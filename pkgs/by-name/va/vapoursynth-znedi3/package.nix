{
  lib,
  stdenv,
  fetchFromGitHub,
  vapoursynth,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-znedi3";
  version = "3.3";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "sekrit-twc";
    repo = "znedi3";
    tag = "r${finalAttrs.version}";
    hash = "sha256-47QqqNkN1FuEaOrhhOOPFUGeXh2GJ3Vj35K271CFyoA=";
  };

  buildInputs = [ vapoursynth ];

  postPatch = ''
    rm -rf vsxx/vapoursynth
    ln -s ${vapoursynth}/include/vapoursynth vsxx/vapoursynth
  '';

  makeFlags = [
    "CPPFLAGS=-DNNEDI3_WEIGHTS_PATH='\"$(out)/share/nnedi3/nnedi3_weights.bin\"'"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86 [
    "X86=1"
    "X86_AVX512=1"
  ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/lib/vapoursynth vsznedi3.so
    install -D -m644 -t $out/share/nnedi3 nnedi3_weights.bin

    runHook postInstall
  '';

  meta = {
    inherit (vapoursynth.meta) platforms;
    description = "Filter for VapourSynth";
    homepage = "https://github.com/sekrit-twc/znedi3";
    license = with lib.licenses; [
      gpl2Plus
      wtfpl
      lgpl21
    ];
    maintainers = with lib.maintainers; [ snaki ];
  };
})
