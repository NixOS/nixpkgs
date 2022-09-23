{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "sanic-routing";
  version = "22.3.0";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-routing";
    rev = "v${version}";
    hash = "sha256-dX+uxrVjtPxX0ba3WUE/JKgj0PZzvFdKr/lXQgASN6Y=";
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
