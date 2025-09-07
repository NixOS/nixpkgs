{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "2.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "htseq";
    repo = "htseq";
    rev = "release_${version}";
    hash = "sha256-i83BY7/p98/pfYzebolNW/6yNwtb2R5ARCSG3rAq2/M=";
  };

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
  ]
  ++ optional-dependencies.htseq-qa;

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
