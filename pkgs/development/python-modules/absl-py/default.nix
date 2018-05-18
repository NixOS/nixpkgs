{ buildPythonPackage
, lib
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d160f7dc39f2f05ddc0bbf3a7bea4cc659fedc45fd9042e87346b24fe1cd00bb";
  };

  propagatedBuildInputs = [ six ];

  # checks use bazel; should be revisited
  doCheck = false;

  meta = {
    description = "Abseil Python Common Libraries";
    homepage = "https://github.com/abseil/abseil-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danharaj ];
  };
}
