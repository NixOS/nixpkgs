{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-yate";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eventphone";
    repo = "python-yate";
    tag = "v${version}";
    hash = "sha256-/tlDme4RmO9XH5PNTvK2yVzbF+iDNeCY21nArq6NU+g=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yate" ];

  meta = {
    description = "Python library for the yate telephony engine";
    mainProgram = "yate_callgen";
    homepage = "https://github.com/eventphone/python-yate";
    changelog = "https://github.com/eventphone/python-yate/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ clerie ];
  };
}
