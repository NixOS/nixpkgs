{ lib, jdk, buildPythonPackage, fetchPypi, six, py4j }:

buildPythonPackage rec {
  pname = "databricks-connect";
  version = "7.1.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bae28fab1e08b709553c8efbeefc5b0ee4f5540a13a04e61fb3d348814823e16";
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
