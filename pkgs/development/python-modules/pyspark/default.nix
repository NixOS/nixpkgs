{ buildPythonPackage, fetchPypi, stdenv, py4j }:

buildPythonPackage rec {
  pname = "pyspark";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ab07ed12c3c9035bfaad93921887736abf89130130b38de7dfa985e50542438";
  };

  # pypandoc is broken with pandoc2, so we just lose docs.
  postPatch = ''
    sed -i "s/'pypandoc'//" setup.py

    # Current release works fine with py4j 0.10.8.1
    substituteInPlace setup.py --replace py4j==0.10.7 'py4j>=0.10.7,<0.11'
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
