{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "sanic-routing";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-routing";
    rev = "v${version}";
    hash = "sha256-MN6A8CtDVxj34eehr3UIwCT09VOfcruVX+/iImr1MgY=";
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
