{ buildPythonPackage
, lib
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.1.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "94943ed0cd77077fe2d18e79b2f28d3e92f585f7d1c6edc75e640121f3c5d580";
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
