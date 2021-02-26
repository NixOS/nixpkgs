{ buildPythonPackage, fetchPypi, lib, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4f2ced43394ad773f7b516a4bbcb5821a940462a17b1a25f175c83771b62ebc";
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
