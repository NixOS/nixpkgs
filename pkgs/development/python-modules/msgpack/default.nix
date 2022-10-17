{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "1.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9dhpwY8DAgLrQS8Iso0q/upVPWYTruieIA16yn7wH18=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "msgpack"
  ];

  meta = with lib;  {
    description = "MessagePack serializer implementation";
    homepage = "https://github.com/msgpack/msgpack-python";
    changelog = "https://github.com/msgpack/msgpack-python/blob/master/ChangeLog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
