{ lib, buildPythonPackage, fetchPypi, pydns }:

buildPythonPackage rec {
  pname = "pyspf";
  version = "2.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18j1rmbmhih7q6y12grcj169q7sx1986qn4gmpla9y5gwfh1p8la";
  };

  propagatedBuildInputs = [ pydns ];

  meta = with lib; {
    homepage = http://bmsi.com/python/milter.html;
    description = "Python API for Sendmail Milters (SPF)";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2;
  };
}
