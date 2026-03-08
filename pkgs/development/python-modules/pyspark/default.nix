{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  py4j,

  # optional-dependencies
  googleapis-common-protos,
  graphviz,
  grpcio-status,
  grpcio,
  numpy,
  pandas,
  pyarrow,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyspark";
  version = "4.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-d/eJhKqE++hlxxfdN7SZE7TlyX1272gk+TLxrvpmIew=";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py
  '';

  build-system = [ setuptools ];

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

  dependencies = [ py4j ];

  optional-dependencies = {
    connect = [
      pandas
      pyarrow
      grpcio
      grpcio-status
      googleapis-common-protos
      zstandard
      graphviz
    ];
    ml = [ numpy ];
    mllib = [ numpy ];
    pandas_on_spark = [
      pandas
      pyarrow
    ];
    pipelines =
      finalAttrs.passthru.optional-dependencies.connect ++ finalAttrs.passthru.optional-dependencies.sql;
    sql = [
      pandas
      pyarrow
    ];
  };

  # Tests assume running spark instance
  doCheck = false;

  pythonImportsCheck = [ "pyspark" ];

  meta = {
    description = "Python bindings for Apache Spark";
    homepage = "https://github.com/apache/spark/tree/master/python";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sarahec
      shlevy
    ];
  };
})
