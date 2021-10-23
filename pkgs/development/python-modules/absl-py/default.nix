{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "absl-py";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cteC++r7pmuj5SXUa8yslJuaF02/ZiM+UOzgnuaI3IE=";
  };

  propagatedBuildInputs = [
    six
  ];

  # checks use bazel; should be revisited
  doCheck = false;

  pythonImportsCheck = [
    "absl"
  ];

  meta = with lib; {
    description = "Abseil Python Common Libraries";
    homepage = "https://github.com/abseil/abseil-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ danharaj ];
  };
}
