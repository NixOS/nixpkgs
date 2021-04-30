{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, httpcore
, httpx
, pytest-asyncio
, sanic
, websockets
}:

buildPythonPackage rec {
  pname = "sanic-testing";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-testing";
    rev = "v${version}";
    hash = "sha256-hBAq+/BKs0a01M89Nb8HaClqxB+W5PTfjVzef/m9SWs=";
  };

  propagatedBuildInputs = [ httpx sanic websockets httpcore ];

  # `sanic` is explicitly set to null when building `sanic` itself
  # to prevent infinite recursion.  In that case we skip running
  # the package at all.
  doCheck = sanic != null;
  dontUsePythonImportsCheck = sanic == null;

  checkInputs = [ pytestCheckHook pytest-asyncio ];
  pythonImportsCheck = [ "sanic_testing" ];

  meta = with lib; {
    description = "Core testing clients for the Sanic web framework";
    homepage = "https://github.com/sanic-org/sanic-testing";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
