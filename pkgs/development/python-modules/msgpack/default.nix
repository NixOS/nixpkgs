{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
, borgbackup
}:

buildPythonPackage rec {
  pname = "msgpack";
  version = "1.0.7";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vy78k9t6TSfkBFAZdcptLZd1cFwtkiOQ2Hj892jZLIc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "msgpack"
  ];

  passthru.tests = {
    # borgbackup is sensible to msgpack versions: https://github.com/borgbackup/borg/issues/3753
    # please be mindful before bumping versions.
    inherit borgbackup;
  };

  meta = with lib;  {
    description = "MessagePack serializer implementation";
    homepage = "https://github.com/msgpack/msgpack-python";
    changelog = "https://github.com/msgpack/msgpack-python/blob/v${version}/ChangeLog.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
