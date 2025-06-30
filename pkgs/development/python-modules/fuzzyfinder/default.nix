{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "fuzzyfinder";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amjith";
    repo = "fuzzyfinder";
    tag = "v${version}";
    hash = "sha256-Zqh2H2d2TCxErmEE9gQwdpzZBGsjeQIo3AxBsc+C5u0=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fuzzyfinder" ];

  meta = with lib; {
    changelog = "https://github.com/amjith/fuzzyfinder/blob/${src.tag}/CHANGELOG.rst";
    description = "Fuzzy Finder implemented in Python";
    homepage = "https://github.com/amjith/fuzzyfinder";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
