{ buildPythonPackage
, lib
, pythonOlder
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9129186431e150d7fe455f1cb1ecbb92bb5dba9da9bc3ef7b012d98c4db2526";
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
