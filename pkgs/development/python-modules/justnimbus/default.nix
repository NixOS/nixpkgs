{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "justnimbus";
  version = "0.7.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "kvanzuijlen";
    repo = "justnimbus";
    rev = "refs/tags/${version}";
    hash = "sha256-FsuvpmMWBYI1LheO3NFfCeaW4m3YQ41Tc81TP3gdNqo=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "justnimbus" ];

  meta = with lib; {
    description = "Library for the JustNimbus API";
    homepage = "https://github.com/kvanzuijlen/justnimbus";
    changelog = "https://github.com/kvanzuijlen/justnimbus/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
