{ lib
, buildPythonPackage
, fetchPypi
, py4j
}:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6Z+n3pK+QGiEv9gxwyuTBqOpneRM/Dmi7vtu0HRF1fo=";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    substituteInPlace setup.py \
      --replace py4j== 'py4j>='
  '';

  propagatedBuildInputs = [
    py4j
  ];

  # Tests assume running spark instance
  doCheck = false;

  pythonImportsCheck = [
    "pyspark"
  ];

  meta = with lib; {
    description = "Python bindings for Apache Spark";
    homepage = "https://github.com/apache/spark/tree/master/python";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    maintainers = [ maintainers.shlevy ];
  };
}
