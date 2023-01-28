{ lib
, buildPythonPackage
, fetchPypi
, pbr
, requests
, pytestCheckHook
, waitress
}:

buildPythonPackage rec {
  pname = "requests-unixsocket";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KDBCg+qTV9Rf/1itWxHkdwjPv1gGgXqlmyo2Mijulx4=";
  };

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    waitress
  ];

  pythonImportsCheck = [
    "requests_unixsocket"
  ];

  meta = with lib; {
    description = "Use requests to talk HTTP via a UNIX domain socket";
    homepage = "https://github.com/msabramo/requests-unixsocket";
    license = licenses.asl20;
    maintainers = with maintainers; [ catern ];
  };
}
