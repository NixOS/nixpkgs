{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "sanic-routing";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-routing";
    rev = "v${version}";
    hash = "sha256-ZMl8PB9E401pUfUJ4tW7nBx1TgPQQtx9erVni3zP+lo=";
  };

  checkInputs = [ pytestCheckHook pytest-asyncio ];
  pythonImportsCheck = [ "sanic_routing" ];

  meta = with lib; {
    description = "Core routing component for the Sanic web framework";
    homepage = "https://github.com/sanic-org/sanic-routing";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
