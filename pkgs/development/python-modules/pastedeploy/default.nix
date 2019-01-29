{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "1.5.2";
  pname = "PasteDeploy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5858f89a255e6294e63ed46b73613c56e3b9a2d82a42f1df4d06c8421a9e3cb";
  };

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Load, configure, and compose WSGI applications and servers";
    homepage = http://pythonpaste.org/deploy/;
    license = licenses.mit;
  };

}
