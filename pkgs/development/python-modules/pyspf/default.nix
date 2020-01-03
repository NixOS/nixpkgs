{ lib, buildPythonPackage, fetchPypi, pydns }:

buildPythonPackage rec {
  pname = "pyspf";
  version = "2.0.13"; # version 2.0.13 should not be used, see #72791

  src = fetchPypi {
    inherit pname version;
    sha256 = "62dc1be39519e343202d480da7ef93d834b5a50cd4f217bef9335ed15292929b";
  };

  propagatedBuildInputs = [ pydns ];

  meta = with lib; {
    homepage = http://bmsi.com/python/milter.html;
    description = "Python API for Sendmail Milters (SPF)";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2;
  };
}
