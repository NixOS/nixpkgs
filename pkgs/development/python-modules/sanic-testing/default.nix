{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, httpx
, pytest-asyncio
, sanic
, websockets
}:

buildPythonPackage rec {
  pname = "sanic-testing";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-testing";
    rev = "v${version}";
    sha256 = "0li984imqmqc001iw4m4b6cqik3d9nb4b3yvamvbwkb6hgd94sck";
  };

  propagatedBuildInputs = [
    httpx
    sanic
    websockets
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/sanic-org/sanic-testing/issues/19
    substituteInPlace setup.py \
      --replace '"websockets==8.1",' '"websockets>=9.1",'
  '';

  # `sanic` is explicitly set to null when building `sanic` itself
  # to prevent infinite recursion.  In that case we skip running
  # the package at all.
  doCheck = sanic != null;
  dontUsePythonImportsCheck = sanic == null;

  pythonImportsCheck = [ "sanic_testing" ];

  meta = with lib; {
    description = "Core testing clients for the Sanic web framework";
    homepage = "https://github.com/sanic-org/sanic-testing";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
