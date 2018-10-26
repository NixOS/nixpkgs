{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.6.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f99c861822884cb00badbd5f364ee32b90a157084a6768040793988c6b92bff";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Distributed and parallel python";
    homepage = https://github.com/uqfoundation;
    license = licenses.bsd3;
  };

}
