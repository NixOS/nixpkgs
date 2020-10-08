{ lib, jdk, buildPythonPackage, fetchPypi, six, py4j }:

buildPythonPackage rec {
  pname = "databricks-connect";
  version = "7.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7f508c84edc7f80a131650b892889624e4457c10f44318465dd3f7b8cf5be6d";
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
