{ lib, buildPythonPackage, fetchPypi
, enum34, hpack, hyperframe, pytestCheckHook, hypothesis }:

buildPythonPackage rec {
  pname = "h2";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb7ac7099dd67a857ed52c815a6192b6b1f5ba6b516237fc24a085341340593d";
  };

  propagatedBuildInputs = [ enum34 hpack hyperframe ];

  checkInputs = [ pytestCheckHook hypothesis ];

  meta = with lib; {
    description = "HTTP/2 State-Machine based protocol implementation";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
