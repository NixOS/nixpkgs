{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  cmake,
  cython,
  distutils,
  ninja,
  scikit-build,
  setuptools,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  espeak-ng,

  # dependencies
  onnxruntime,
  pathvalidate,

  # optional-dependencies
  flask,
  jsonargparse,
  librosa,
  lightning,
  onnx,
  pyopenjtalk-plus,
  pysilero-vad,
  sentence-stream,
  tensorboard,
  tensorboardx,
  torch,
  transformers,
  unicode-rbnf,

  # tests
  pytestCheckHook,
}:

let
  # https://github.com/OHF-Voice/piper1-gpl/blob/v1.7.0/CMakeLists.txt#L33-L40
  espeak-ng' = espeak-ng.override {
    asyncSupport = false;
    klattSupport = false;
    mbrolaSupport = false;
    pcaudiolibSupport = false;
    sonicSupport = false;
    speechPlayerSupport = false;
  };
in

buildPythonPackage (finalAttrs: {
  pname = "piper-tts";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "piper1-gpl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rlox5n+EWJf/464L/0rwjEmSEkxo2XQQhubq7cbLvL8=";
  };

  patches = [
    # https://github.com/OHF-Voice/piper1-gpl/pull/17
    ./cmake-system-libs.patch
  ];

  build-system = [
    cmake
    ninja
    scikit-build
    setuptools
    # monotonic_align extension, used by the train extra
    cython
    distutils
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  env.CMAKE_ARGS = toString [
    (lib.cmakeFeature "UCD_STATIC_LIB" "${espeak-ng'.ucd-tools}/libucd.a")
  ];

  buildInputs = [
    espeak-ng'
  ];

  postBuild = ''
    cythonize --inplace src/piper/train/vits/monotonic_align/core.pyx
  '';

  dependencies = [
    onnxruntime
    pathvalidate
  ];

  optional-dependencies = {
    alignment = [
      onnx
    ];
    http = [
      flask
    ];
    ja = [
      pyopenjtalk-plus
    ];
    train = [
      jsonargparse
      librosa
      lightning
      onnx
      pysilero-vad
      tensorboard
      tensorboardx
      torch
    ]
    ++ jsonargparse.optional-dependencies.signatures;
    zh = [
      # g2pw # not packaged
      transformers
      sentence-stream
      unicode-rbnf
    ];
  };

  postInstall = ''
    ln -s ${espeak-ng'}/share/espeak-ng-data $out/${python.sitePackages}/piper/

    # imported as piper.train.vits.monotonic_align.monotonic_align.core,
    # see build_monotonic_align.sh
    install -Dm755 -t $out/${python.sitePackages}/piper/train/vits/monotonic_align/monotonic_align \
      src/piper/train/vits/monotonic_align/core.*.so
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: cannot cache function '__o_fold': no locator available for file '/nix/store/byi2l9xb88xan6vf88xcx9vbklyvxha5-python3.14-librosa-1.0.0/lib/python3.14/site-packages/librosa/core/notation.py'
    "test_training_phonemize_matches_inference_with_vowel_clusters"
  ];

  pythonImportsCheck = [
    "piper"
    "piper.tashkeel"
    "piper.hebrew"
    "piper.train"
    "piper.train.vits"
  ];

  meta = {
    changelog = "https://github.com/OHF-Voice/piper1-gpl/releases/tag/v${finalAttrs.version}";
    description = "Fast, local neural text to speech system";
    homepage = "https://github.com/OHF-Voice/piper1-gpl";
    license = with lib.licenses; [
      gpl3Plus
      # src/piper/g2pw_onnx.py, see licenses/LICENSE.g2pW-Apache-2.0
      asl20
      # bundled models in src/piper/{hebrew,tashkeel}
      mit
    ];
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "piper";
  };
})
