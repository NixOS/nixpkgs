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
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "pygmars";
    rev = "refs/tags/v${version}";
    hash = "sha256-RwAZ1ZLh0zgGshSv7LleBHMotKapDFtD69ptqQnr0EA=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pygmars" ];

  meta = with lib; {
    description = "Python lexing and parsing library";
    homepage = "https://github.com/nexB/pygmars";
    changelog = "https://github.com/nexB/pygmars/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
