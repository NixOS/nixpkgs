{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  libdeflate,
  setuptools,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pyseq-align";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lioscro";
    repo = "pyseq-align";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-r7d/HmN3JPQgQiRzRJMFdSGspGWDvmnEM7EPPt1ecbQ=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = "pyseq_align";

  preCheck = ''
    rm pyseq_align/__init__.py
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python interface for the seq-align C library";
    longDescription = ''
      Seq-align is an implementations of optimal local (Smith-Waterman) and
      global (Needleman-Wunsch) alignment algorithms. pyseq-align wraps these,
      which enables efficient bioinformatics sequence alignment in Python.
    '';
    downloadPage = "https://github.com/Lioscro/pyseq-align";
    homepage = "https://pysam.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
  };
}
