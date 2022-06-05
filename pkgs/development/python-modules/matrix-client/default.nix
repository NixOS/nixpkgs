{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, requests
, responses
, urllib3
}:

buildPythonPackage rec {
  pname = "matrix_client";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mii7ib3bah5ppqs7i8sjv5l0zbl57011908m4l0jbyby90ayy06";
  };

  propagatedBuildInputs = [
    requests
    urllib3
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace setup.py --replace \
      "pytest-runner~=5.1" ""
  '';

  pythonImportsCheck = [ "matrix_client" ];

  meta = with lib; {
    description = "Python Matrix Client-Server SDK";
    homepage = "https://github.com/matrix-org/matrix-python-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ olejorgenb ];
  };
}
