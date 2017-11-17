{ buildPythonPackage
, lib
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.1.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "017wc85i7l3vpjzw3shgb7k7n0jfid88g09dlf1kgdy4ll0sjfax";
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
