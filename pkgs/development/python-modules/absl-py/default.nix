{ buildPythonPackage
, lib
, pythonOlder
, fetchPypi
, setuptools
, six
, enum34
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eCB5DvuzFnOc3otOGTVyQ/w2CKFSAkKIUT3ZaNfZWf8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    maintainers = with lib.maintainers; [ ];
  };
}
