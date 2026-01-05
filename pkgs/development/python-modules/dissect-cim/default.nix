{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dissect-cim";
  version = "3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.cim";
    tag = version;
    hash = "sha256-S3EbGWLajfWTy0h0cmECHmHH/QLu5WmhnqTCQWSbYs8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.cim" ];

  # gzip.BadGzipFile: Not a gzipped file
  doCheck = false;

  meta = with lib; {
    description = "Dissect module implementing a parser for the Windows Common Information Model (CIM) database";
    homepage = "https://github.com/fox-it/dissect.cim";
    changelog = "https://github.com/fox-it/dissect.cim/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
