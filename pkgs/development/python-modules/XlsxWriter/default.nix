{lib, buildPythonPackage, fetchFromGitHub}:

buildPythonPackage rec {

  pname = "XlsxWriter";
  version = "1.2.9";

  # PyPI release tarball doesn't contain tests so let's use GitHub. See:
  # https://github.com/jmcnamara/XlsxWriter/issues/327
  src = fetchFromGitHub{
    owner = "jmcnamara";
    repo = pname;
    rev = "RELEASE_${version}";
    sha256 = "08pdca5ssi50bx2xz52gkmjix2ybv5i4bjw7yd6yfiph0y0qsbsb";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = "https://xlsxwriter.readthedocs.io/";
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };

}
