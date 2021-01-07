{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qal827pcllmqjk3gj4jfm82sq9kp1xiygqadc795a8yw13j3c65";
  };

  checkInput = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
