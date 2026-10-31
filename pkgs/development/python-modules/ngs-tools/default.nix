{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  joblib,
  numba,
  numpy,
  pysam,
  shortuuid,
  tqdm,
  typing-extensions,
  pyseq-align,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "ngs-tools";
  version = "1.8.6";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "ngs-tools";
    owner = "Lioscro";
    tag = "v${version}";
    hash = "sha256-w0BQtLcoBvoIzfwRG1YWgviFrQAj1w8Katx5SSrqbps=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = "ngs_tools";

  nativeCheckInputs = [ pytestCheckHook ];

  dependencies = [
    joblib
    numba
    numpy
    pysam
    shortuuid
    tqdm
    typing-extensions
    pyseq-align
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reusable tools for working with next-generation sequencing (NGS) data";
    downloadPage = "https://github.com/Lioscro/ngs-tools";
    homepage = "https://ngs-tools.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
  };
}
