{ lib, buildPythonPackage, fetchPypi, pydns }:

buildPythonPackage rec {
  pname = "pyspf";
  version = "2.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16wjj99d2pikz6z1gwnl1jjvad6qjgpsf3a85lh47qqrjpiipp32";
  };

  propagatedBuildInputs = [ pydns ];

  meta = with lib; {
    homepage = http://bmsi.com/python/milter.html;
    description = "Python API for Sendmail Milters (SPF)";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2;
  };
}
