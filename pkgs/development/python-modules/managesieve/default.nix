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
  version = "0.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2CCb6h69H58YT1byj/fkrfzGsMUbr0GHpJLcMpsSE/M=";
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
