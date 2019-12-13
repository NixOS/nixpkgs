{ lib, buildPythonPackage, fetchFromGitHub, pydns }:

buildPythonPackage rec {
  pname = "pyspf";
  version = "2.0.14pre1";

  src = fetchFromGitHub {
    owner = "sdgathman";
    repo = pname;
    rev = "pyspf-${version}";
    sha256 = "17d8namkrsmmhc6p4226pffgafivn59qqlj42sq3sma10i09r0c2";
  };

  propagatedBuildInputs = [ pydns ];

  meta = with lib; {
    homepage = http://bmsi.com/python/milter.html;
    description = "Python API for Sendmail Milters (SPF)";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl2;
  };
}
