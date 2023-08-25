{ lib
, buildPythonPackage
, fetchPypi
, asgiref
, httpx
, pdm-backend
, pdm-pep517
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "a2wsgi";
  version = "1.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qQb2LAJQ6wIBEguTQX3QsSsQW12zWvQxv+hu8NxburI=";
  };

  nativeBuildInputs = [
    pdm-backend
    pdm-pep517
  ];

  nativeCheckInputs = [
    asgiref
    httpx
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Convert WSGI app to ASGI app or ASGI app to WSGI app";
    homepage = "https://github.com/abersheeran/a2wsgi";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
