{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sanic-routing";
  version = "23.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-routing";
    rev = "refs/tags/v${version}";
    hash = "sha256-IUubPd6mqtCfY4ruI/8wkFcAcS0xXHWbe9RzDac5kRc=";
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sanic_routing" ];

  meta = with lib; {
    description = "Core routing component for the Sanic web framework";
    homepage = "https://github.com/sanic-org/sanic-routing";
    changelog = "https://github.com/sanic-org/sanic-routing/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
