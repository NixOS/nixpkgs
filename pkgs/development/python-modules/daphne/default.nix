{ lib
, stdenv
, asgiref
, autobahn
, buildPythonPackage
, django
, fetchFromGitHub
, hypothesis
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, twisted
}:

buildPythonPackage rec {
  pname = "daphne";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    hash = "sha256-vPMrmC2B0Pcvk8Y1FsJ4PXnzIMtPod7lL2u0IYNVUxc=";
  };

  propagatedBuildInputs = [
    asgiref
    autobahn
    twisted
  ] ++ twisted.optional-dependencies.tls;

  nativeCheckInputs = [
    django
    hypothesis
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  # Most tests fail on darwin
  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "daphne"
  ];

  meta = with lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    homepage = "https://github.com/django/daphne";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
