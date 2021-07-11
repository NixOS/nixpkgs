{ buildPythonPackage, fetchPypi, lib, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e25ebb18756e9715f4d26848cc7e558035025da74b4fc325a0ebc05ff538e65";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    substituteInPlace setup.py --replace py4j==0.10.9 'py4j>=0.10.9,<0.11'
  '';

  postFixup = ''
    # find_python_home.py has been wrapped as a shell script
    substituteInPlace $out/bin/find-spark-home \
        --replace 'export SPARK_HOME=$($PYSPARK_DRIVER_PYTHON "$FIND_SPARK_HOME_PYTHON_SCRIPT")' \
                  'export SPARK_HOME=$("$FIND_SPARK_HOME_PYTHON_SCRIPT")'

    # patch PYTHONPATH in pyspark so that it properly looks at SPARK_HOME
    substituteInPlace $out/bin/pyspark \
        --replace 'export PYTHONPATH="''${SPARK_HOME}/python/:$PYTHONPATH"' \
                  'export PYTHONPATH="''${SPARK_HOME}/..:''${SPARK_HOME}/python/:$PYTHONPATH"'
  '';

  propagatedBuildInputs = [ py4j ];

  # Tests assume running spark...
  doCheck = false;

  meta = with lib; {
    description = "Apache Spark";
    homepage = "https://github.com/apache/spark/tree/master/python";
    license = licenses.asl20;
    maintainers = [ maintainers.shlevy ];
  };
}
