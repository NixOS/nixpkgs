{
  addict,
  buildPythonPackage,
  espeak-ng,
  fetchFromGitHub,
  fetchpatch2,
  fugashi,
  hatchling,
  jaconv,
  jamo,
  jieba,
  lib,
  nltk,
  num2words,
  ordered-set,
  phonemizer,
  pip,
  pypinyin,
  pythonOlder,
  regex,
  replaceVars,
  spacy-curated-transformers,
  spacy,
  pytestCheckHook,
  stdenv,
  torch,
  transformers,
  unidic,
}:

buildPythonPackage {
  pname = "misaki";
  version = "0-unstable-2025-06-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hexgrad";
    repo = "misaki";
    rev = "49ddead831fc1a46beab3f9cb6064d93fd3f6347";
    hash = "sha256-XkmCG0Vkw/iyLNmwhaW5gp6sg8ieHFeK6fBJ3Jb+J8Q=";
  };

  patches = [
    (fetchpatch2 {
      name = "pr82-remove-pip-dependency.patch";
      url = "https://github.com/hexgrad/misaki/commit/7d2fdff9fe046dd52b638bbb1b243fb789f4cb31.patch?full_index=1";
      hash = "sha256-N796YWrGe51FYVdxbQ8omJxeGdvOAiKEUKhhm10TQO8=";
    })
    (replaceVars ./set-espeak-paths.patch {
      espeak-library-path = "${lib.getLib espeak-ng}/lib/libespeak-ng${stdenv.hostPlatform.extensions.sharedLibrary}";
      espeak-data-path = "${lib.getLib espeak-ng}/share/espeak-ng-data";
    })
  ];

  build-system = [
    hatchling
  ];

  dependencies = [
    addict
    regex
  ];

  # See https://github.com/hexgrad/misaki/blob/main/pyproject.toml#L26
  passthru.optional-dependencies = {
    en = [
      num2words
      spacy
      spacy-curated-transformers
      phonemizer
      # phonemizer-fork -- we already patch phonemizer in nixpkgs, no need for the "-fork" version
      # espeakng-loader -- ./set-espeak-paths.patch obviates the need for this
      torch
      transformers
    ];
    ja = [
      fugashi
      jaconv
      # mojimoji -- not packaged as of 2025-06-16
      unidic
      # pyopenjtalk -- not packaged as of 2025-06-16
    ];
    ko = [
      jamo
      nltk
    ];
    zh = [
      jieba
      ordered-set
      pypinyin
      # cn2an -- not packaged as of 2025-06-16
      # pypinyin-dict -- not packaged as of 2025-06-16
    ];
    vi = [
      num2words
      spacy
      spacy-curated-transformers
      # underthesea -- not packaged as of 2025-06-16
    ];
    # he = [ mishkal-hebrew ]; -- not packaged as of 2025-06-16
  };

  # Package does not have tests as of 2025-06-16, but phonemizer is required for
  # pythonImportsCheck.
  nativeCheckInputs = [ phonemizer ];

  pythonImportsCheck = [
    "misaki"
    "misaki.espeak"
  ];

  meta = {
    description = "G2P engine for TTS";
    homepage = "https://github.com/hexgrad/misaki";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
