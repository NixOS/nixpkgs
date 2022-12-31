{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "roster";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RnxEB11VSzh8Us3fAlQZxGr02qdMbZAKBX1q1v3sX00=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Python object registers to keep track of your classes, functions and data.";
    homepage = "https://github.com/tombulled/roster";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
