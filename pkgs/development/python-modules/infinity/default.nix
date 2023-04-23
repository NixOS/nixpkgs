{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "infinity";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1npcc4adcc3c9diw4kgmd5c0ikym1iz364p2zp6gs011rqaprald";
  };

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  meta = with lib; {
    description = "All-in-one infinity value for Python. Can be compared to any object.";
    homepage = "https://github.com/kvesteri/infinity";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mupdt ];
  };
}
