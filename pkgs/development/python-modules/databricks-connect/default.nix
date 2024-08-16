{
  lib,
  jdk8,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
  py4j,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "databricks-connect";
  version = "11.3.33";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KcqJ2B2df85H/VIx4ToX0pJ7rYbjDRp3eR7jAFW67do=";
  };

  sourceRoot = ".";

  build-system = [ setuptools ];

  dependencies = [
    py4j
    six
    jdk8
  ];

  # requires network access
  doCheck = false;

  pythonRelaxDeps = [ "py4j" ];

  preFixup = ''
    substituteInPlace "$out/bin/find-spark-home" \
      --replace-fail find_spark_home.py .find_spark_home.py-wrapped
  '';

  pythonImportsCheck = [
    "pyspark"
    "six"
    "py4j"
  ];

  meta = with lib; {
    description = "Client for connecting to remote Databricks clusters";
    homepage = "https://pypi.org/project/databricks-connect";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.databricks;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
