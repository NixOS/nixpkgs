{ lib
, jdk8
, buildPythonPackage
, fetchPypi
, six
, py4j
, pythonOlder
}:

buildPythonPackage rec {
  pname = "databricks-connect";
  version = "9.1.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gSclZatH5r3r6o8K2gXaNlkowQxFT7h0t/0ubr3d0n0=";
  };

  sourceRoot = ".";

  propagatedBuildInputs = [ py4j six jdk8 ];

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
