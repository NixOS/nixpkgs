{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "sanic-routing";
  version = "21.12.0";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-routing";
    rev = "v${version}";
    hash = "sha256-IN+keJ5OI++p33/FgW5Xo+Pk09VuR7EASDF7G6eWvM4=";
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
