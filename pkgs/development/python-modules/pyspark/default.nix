{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pandas,
  py4j,
  pyarrow,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bv/Jzpjt8jH01oP9FPcnBim/hFjGKNaiYg3tS7NPPLk=";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    substituteInPlace setup.py \
      --replace py4j== 'py4j>='
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

  optional-dependencies = {
    ml = [ numpy ];
    mllib = [ numpy ];
    sql = [
      numpy
      pandas
      pyarrow
    ];
  };

  # Tests assume running spark instance
  doCheck = false;

  pythonImportsCheck = [ "pyspark" ];

  meta = with lib; {
    description = "Python bindings for Apache Spark";
    homepage = "https://github.com/apache/spark/tree/master/python";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ shlevy ];
  };
}
