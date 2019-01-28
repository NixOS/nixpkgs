{ buildPythonPackage
, lib
, pythonOlder
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08ydsayzm0292khphkv6rvccmbkn1b5x3f8hk7vkn0fn9fg1h647";
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
