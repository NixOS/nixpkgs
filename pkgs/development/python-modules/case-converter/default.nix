{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "case-converter";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisdoherty4";
    repo = "python-case-converter";
    tag = "v${version}";
    hash = "sha256-PS/9Ndl3oD9zimEf819dNoSAeNJPndVjT+dkfW7FIJs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "caseconverter" ];

  doCheck = true;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Case conversion library for Python";
    homepage = "https://github.com/chrisdoherty4/python-case-converter";
    changelog = "https://github.com/chrisdoherty4/python-case-converter/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
