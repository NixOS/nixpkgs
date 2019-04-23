{lib, buildPythonPackage, fetchFromGitHub}:

buildPythonPackage rec {

  pname = "XlsxWriter";
  version = "1.1.6";

  # PyPI release tarball doesn't contain tests so let's use GitHub. See:
  # https://github.com/jmcnamara/XlsxWriter/issues/327
  src = fetchFromGitHub{
    owner = "jmcnamara";
    repo = pname;
    rev = "RELEASE_${version}";
    sha256 = "1hmagwh2k61r90a9xgp3xj24wb97ckllvgn82vsin9kvhhj1459i";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };

}
