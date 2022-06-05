{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "51fdc7fb93615286428ee7758cecc2f374d5ff363bdd884c7ea622a7a327a81e";
  };

  nativeBuildInputs = [
    setuptools
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib;  {
    homepage = "https://github.com/msgpack/msgpack-python";
    description = "MessagePack serializer implementation for Python";
    changelog = "https://github.com/msgpack/msgpack-python/blob/master/ChangeLog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
