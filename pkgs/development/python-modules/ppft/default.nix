{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "ppft";
  version = "1.6.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e1aa0d74f832f0528234890165f3e64d34b3103ec1db7c93c9e7f2ad8cc18d2";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Distributed and parallel python";
    homepage = https://github.com/uqfoundation;
    license = licenses.bsd3;
  };

}
