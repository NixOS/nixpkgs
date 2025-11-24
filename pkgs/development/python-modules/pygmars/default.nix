{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pygmars";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "pygmars";
    tag = "v${version}";
    hash = "sha256-AbBhWR9ycOFrxS7Vz0bSsSyS3FEEm2bXJAvMhIba6XQ=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pygmars" ];

  meta = with lib; {
    description = "Python lexing and parsing library";
    homepage = "https://github.com/nexB/pygmars";
    changelog = "https://github.com/aboutcode-org/pygmars/blob/${src.tag}/CHANGELOG.rst";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
