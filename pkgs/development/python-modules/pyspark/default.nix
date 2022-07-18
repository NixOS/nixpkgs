{ lib
, buildPythonPackage
, fetchPypi
, py4j
}:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fr6OlQVke00STVqC/KYN/TiRAhz4rWxeyId37uzpLPc=";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    substituteInPlace setup.py \
      --replace py4j==0.10.9.3 'py4j>=0.10.9,<0.11'
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
