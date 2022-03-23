{ lib
, buildPythonPackage
, fetchPypi
, py4j
}:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C4E1kmLsbprHjDUzROfeAmAn0UDG3vlJ/w2Aq3D4mlQ=";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    substituteInPlace setup.py \
      --replace py4j==0.10.9.2 'py4j>=0.10.9,<0.11'
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
    license = licenses.asl20;
    maintainers = [ maintainers.shlevy ];
  };
}
