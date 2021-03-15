{ lib, jdk, buildPythonPackage, fetchPypi, six, py4j }:

buildPythonPackage rec {
  pname = "databricks-connect";
  version = "7.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8aa75740900f9b4bcc6d3f2bd815408dba30dc9a512bcc950b93e7353ec45133";
  };

  sourceRoot = ".";

  propagatedBuildInputs = [ py4j six jdk ];

  # requires network access
  doCheck = false;

  prePatch = ''
    substituteInPlace setup.py \
      --replace "py4j==0.10.9" "py4j"
  '';

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
