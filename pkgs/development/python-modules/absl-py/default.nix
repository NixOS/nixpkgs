{ buildPythonPackage
, lib
, pythonOlder
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b943d1c567743ed0455878fcd60bc28ac9fae38d129d1ccfad58079da00b8951";
  };

  propagatedBuildInputs = [
    six
  ] ++ lib.optionals (pythonOlder "3.4") [
    enum34
  ];

  # checks use bazel; should be revisited
  doCheck = false;

  meta = {
    description = "Abseil Python Common Libraries";
    homepage = "https://github.com/abseil/abseil-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danharaj ];
  };
}
