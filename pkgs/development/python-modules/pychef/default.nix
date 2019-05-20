{ stdenv
, buildPythonPackage
, fetchPypi
, six
, requests
, mock
, unittest2
}:

buildPythonPackage rec {
  pname    = "PyChef";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zdz8lw545cd3a34cpib7mdwnad83gr2mrrxyj3v74h4zhwabhmg";
  };

  propagatedBuildInputs = [ six requests mock unittest2 ];

  # FIXME
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/coderanger/pychef;
    description = "Python implementation of a Chef API client";
    license = licenses.bsd0;
  };

}
