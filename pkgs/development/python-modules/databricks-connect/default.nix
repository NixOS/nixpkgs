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
  version = "9.1.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-agdky7AhRuObU9GT8IpdgB3SWdHDBRnuoaAtYAlCv/4=";
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
