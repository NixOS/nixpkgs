{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pilight";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DavidLP";
    repo = "pilight";
    tag = version;
    hash = "sha256-8KLEeyf1uwYjsBfIoi+736cu+We6OjLvptCXL539bDA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace pilight/test/test_client.py \
      --replace-fail "from mock import patch, call" "from unittest.mock import patch, call" \
      --replace-fail "pilight_client.isAlive()" "pilight_client.is_alive()"
  '';

  pythonImportsCheck = [ "pilight" ];

  meta = {
    description = "Pure python module to connect to a pilight daemon to send and receive commands";
    homepage = "https://github.com/DavidLP/pilight";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
