{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-mock,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "pykka";
  version = "4.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jodal";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2baFwZPNuVU39Kt5B8QvGKu7jMbg+GZ3ROoTxzPOXac=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "pykka" ];

  meta = with lib; {
    homepage = "https://www.pykka.org/";
    description = "Python implementation of the actor model";
    changelog = "https://github.com/jodal/pykka/releases/tag/v${version}";
    maintainers = [ ];
    license = licenses.asl20;
  };
}
