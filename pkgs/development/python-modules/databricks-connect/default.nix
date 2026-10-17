{
  lib,
  jdk8,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
  py4j,
}:

buildPythonPackage rec {
  pname = "databricks-connect";
  version = "11.3.61";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EUXLjd6XFfK+sldjfkPRe2Pryx5zrmx6HvaAu+/aN/A=";
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

  meta = {
    description = "Client for connecting to remote Databricks clusters";
    homepage = "https://pypi.org/project/databricks-connect";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.databricks;
    maintainers = with lib.maintainers; [ kfollesdal ];
  };
}
