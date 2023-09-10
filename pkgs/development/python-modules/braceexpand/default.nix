{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "braceexpand";
  version = "0.1.7";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version pname;
    sha256 = "01gpcnksnqv6np28i4x8s3wkngawzgs99zvjfia57spa42ykkrg6";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "braceexpand" ];

  meta = with lib; {
    description = "Bash-style brace expansion for Python";
    homepage = "https://github.com/trendels/braceexpand";
    changelog = "https://github.com/trendels/braceexpand/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
