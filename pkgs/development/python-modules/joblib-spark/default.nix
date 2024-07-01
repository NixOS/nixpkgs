{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, wheel
, joblib
, pyspark
}:

buildPythonPackage rec {
  pname = "joblib-spark";
  version = "0.5.2";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "joblib";
    repo = "joblib-spark";
    rev = "v${version}";
    hash = "sha256-RzkeOFAUI4gX2mgQRYw0LZbTTmAWmQvLTmQ8uo4kHa8=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    joblib
    pyspark
  ];

  pythonImportsCheck = [ "joblibspark" ];

  meta = with lib; {
    description = "Joblib Apache Spark Backend";
    homepage = "https://github.com/joblib/joblib-spark";
    changelog = "https://github.com/joblib/joblib-spark/blob/${src.rev}/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ sarahec ];
  };
}
