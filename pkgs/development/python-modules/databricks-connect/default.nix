{ lib, jdk, buildPythonPackage, fetchPypi, six, py4j }:

buildPythonPackage rec {
  pname = "databricks-connect";
  version = "7.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c0f036cf30e00fdc47c983875c72d16a3073ae9be9bcf39371514280f00a82d";
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
