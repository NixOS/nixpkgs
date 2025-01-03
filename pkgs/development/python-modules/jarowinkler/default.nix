{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  rapidfuzz,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jarowinkler";
  version = "2.0.1";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "JaroWinkler";
    tag = "v${version}";
    hash = "sha256-B3upTBNqMyi+CH7Zx04wceEXjGJnr6S3BIl87AQkfbo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ rapidfuzz ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "jarowinkler" ];

  meta = with lib; {
    description = "Library for fast approximate string matching using Jaro and Jaro-Winkler similarity";
    homepage = "https://github.com/maxbachmann/JaroWinkler";
    changelog = "https://github.com/maxbachmann/JaroWinkler/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
