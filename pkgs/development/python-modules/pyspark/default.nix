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
