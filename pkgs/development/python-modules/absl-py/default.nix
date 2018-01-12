{ buildPythonPackage
, lib
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.1.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ea22ae860f3a556511291e7f1284942199c81377f47ec4248163defb1b9e6ee";
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
