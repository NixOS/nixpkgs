{ lib, buildPythonPackage, fetchurl, pydns }:

buildPythonPackage rec {
  name = "pyspf-${version}";
  version = "2.0.12";

  src = fetchurl {
    url = "mirror://sourceforge/pymilter/pyspf/${name}/${name}.tar.gz";
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
