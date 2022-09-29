{ buildPythonPackage
, lib
, pythonOlder
, fetchPypi
, six
, enum34
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9WiAmTjEmrvaiYJiI8mStjCv0jxjgWCteEDP40dxDZc=";
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
    maintainers = with lib.maintainers; [ ];
  };
}
