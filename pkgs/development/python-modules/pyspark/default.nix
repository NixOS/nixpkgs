{ buildPythonPackage, fetchPypi, lib, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38b485d3634a86c9a2923c39c8f08f003fdd0e0a3d7f07114b2fb4392ce60479";
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
