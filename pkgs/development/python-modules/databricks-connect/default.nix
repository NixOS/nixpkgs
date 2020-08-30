{ lib, jdk, buildPythonPackage, fetchPypi, six, py4j }:

buildPythonPackage rec {
  pname = "databricks-connect";
  version = "7.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "996a9d0f271f6c7edbd2d85b2efb6ff4e58d15222e80f87ca17fdbf224e17056";
  };

  sourceRoot = ".";

  propagatedBuildInputs = [ py4j six jdk ];

  # requires network access
  doCheck = false;

  preFixup = ''
      substituteInPlace "$out/bin/find-spark-home" \
      --replace find_spark_home.py .find_spark_home.py-wrapped
  '';

  pythonImportsCheck = [ "pyspark" "six" "py4j" ];

  meta = with lib; {
    description = "Client for connecting to remote Databricks clusters";
    homepage = "https://pypi.org/project/databricks-connect";
    license = licenses.databricks;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
