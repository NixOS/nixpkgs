{ buildPythonPackage
, lib
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.1.9";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c787e3bc7ef8fea7a8a79cf36b0c550b4bd66e13c05d1352fbc5786488befb0";
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
