{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  swig,
  cython,
  matplotlib,
  numpy,
  pandas,
  pysam,
  setuptools,
  pytestCheckHook,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "htseq";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "htseq";
    repo = "htseq";
    rev = "release_${version}";
    hash = "sha256-7ocrmuj9LOtPz9XbI5rKGcdE5JbFz/pZh00Nie65XxE=";
  };

  patches = [
    # https://github.com/htseq/htseq/pull/84
    (fetchpatch {
      name = "replace-distutils-with-sysconfig.patch";
      url = "https://github.com/htseq/htseq/commit/f0f1e464ee9aee56f0b44f905e7b3355b0bb8f29.patch";
      hash = "sha256-yDYkXCPy+YFgnk1rnXwCB998aZwVd5nJeejZIgeEzAo=";
    })
  ];

  nativeBuildInputs = [ swig ];

  build-system = [
    cython
    numpy
    pysam
    setuptools
  ];

  dependencies = [
    numpy
    pysam
  ];

  optional-dependencies = {
    htseq-qa = [ matplotlib ];
  };

  pythonImportsCheck = [ "HTSeq" ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
  ] ++ optional-dependencies.htseq-qa;

  preCheck = ''
    rm -r src HTSeq
    export PATH=$out/bin:$PATH
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release_(.+)"
    ];
  };

  meta = with lib; {
    homepage = "https://htseq.readthedocs.io/";
    description = "Framework to work with high-throughput sequencing data";
    maintainers = with maintainers; [ unode ];
  };
}
