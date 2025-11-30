{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pydevccu";
  version = "0.1.18";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "pydevccu";
    tag = version;
    hash = "sha256-+IUPj27+eU2e215LkF+Qqv5vtRqASPP7dEBTvfT/KEo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.6.0" setuptools
  '';

  pythonRelaxDeps = [ "orjson" ];

  build-system = [ setuptools ];

  dependencies = [ orjson ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydevccu" ];

  meta = {
    description = "HomeMatic CCU XML-RPC Server with fake devices";
    homepage = "https://github.com/SukramJ/pydevccu";
    changelog = "https://github.com/SukramJ/pydevccu/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
