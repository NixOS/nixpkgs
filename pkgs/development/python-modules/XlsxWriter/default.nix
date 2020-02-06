{lib, buildPythonPackage, fetchFromGitHub}:

buildPythonPackage rec {

  pname = "XlsxWriter";
  version = "1.2.6";

  # PyPI release tarball doesn't contain tests so let's use GitHub. See:
  # https://github.com/jmcnamara/XlsxWriter/issues/327
  src = fetchFromGitHub{
    owner = "jmcnamara";
    repo = pname;
    rev = "RELEASE_${version}";
    sha256 = "05y1py5mn1m65bbwhinzv84jd3xj8snvf2795flw0xbxnkn8nd8p";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };

}
