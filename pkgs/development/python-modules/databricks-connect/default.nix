{ lib, jdk8, buildPythonPackage, fetchPypi, six, py4j }:
let
  mkDatabricks = { version, sha256 }: buildPythonPackage rec {
    pname = "databricks-connect";
    inherit version;

    src = fetchPypi {
      inherit pname version sha256;
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
  };
in {
  databricks-connect_7 = mkDatabricks {
    version = "7.3.28";
    sha256 = "sha256-JtsmcvvseJYPm/AAgKCvwvTPaxOd6srb2zHKTJVwgDQ=";
  };

  databricks-connect_9 = mkDatabricks {
    version = "9.1.3";
    sha256 = "sha256-awA8zX6a4n2CkWSrfG9bE+QKUyVBAQae2k+deBeErX8=";
  };
}
