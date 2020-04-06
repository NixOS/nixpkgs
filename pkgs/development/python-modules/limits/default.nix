{ stdenv, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "limits";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c071295307c447f85aaa3c3ab3ce058e29d67010f4fabf278a8e163916e4deab";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false; # ifilter

  meta = with stdenv.lib; {
    description = "Rate limiting utilities";
    license = licenses.mit;
    homepage = https://limits.readthedocs.org/;
  };
}
