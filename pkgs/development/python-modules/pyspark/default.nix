{ buildPythonPackage, fetchPypi, stdenv, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "2.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6839718ce9f779e81153d8a14a843a5c4b2d5e6574f3c916aec241022d717cb2";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    # Current release works fine with py4j 0.10.8.1
    substituteInPlace setup.py --replace py4j==0.10.7 'py4j>=0.10.7,<0.11'
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

  meta = with stdenv.lib; {
    description = "Apache Spark";
    homepage = https://github.com/apache/spark/tree/master/python;
    license = licenses.asl20;
    maintainers = [ maintainers.shlevy ];
  };
}
