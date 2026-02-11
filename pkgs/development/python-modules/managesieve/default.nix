{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "managesieve";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LVwe0Pn6YPIAuoIaxXMfvCbOfS4NAjozkrdMNZDq+uU=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "managesieve" ];

  meta = {
    description = "ManageSieve client library for remotely managing Sieve scripts";
    homepage = "https://managesieve.readthedocs.io/";
    # PSFL for the python module, GPLv3 only for sieveshell
    license = with lib.licenses; [
      gpl3Only
      psfl
    ];
    maintainers = with lib.maintainers; [ dadada ];
    mainProgram = "sieveshell";
  };
}
