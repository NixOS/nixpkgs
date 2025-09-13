{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "managesieve";
  version = "0.8.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LVwe0Pn6YPIAuoIaxXMfvCbOfS4NAjozkrdMNZDq+uU=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "managesieve" ];

  meta = with lib; {
    description = "ManageSieve client library for remotely managing Sieve scripts";
    homepage = "https://managesieve.readthedocs.io/";
    # PSFL for the python module, GPLv3 only for sieveshell
    license = with licenses; [
      gpl3Only
      psfl
    ];
    maintainers = with maintainers; [ dadada ];
    mainProgram = "sieveshell";
  };
}
