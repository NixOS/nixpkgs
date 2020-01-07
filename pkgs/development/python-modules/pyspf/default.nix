{ lib, buildPythonPackage, fetchPypi, pydns }:

buildPythonPackage rec {
  pname = "pyspf";
  version = "2.0.14"; # version 2.0.14 should not be used, see #72791

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ki6ky5fk6kzh8ykd1xy1ryv1hn4l303bxnmwx1g450pl0yz9sp";
  };

  propagatedBuildInputs = [ pydns ];

  meta = with lib; {
    homepage = http://bmsi.com/python/milter.html;
    description = "Python API for Sendmail Milters (SPF)";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2;
  };
}
