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
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2WkCEcX8/vzdGkVHCsK1xazUUkHDr3Hu2WvFRBdGwNU=";
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
