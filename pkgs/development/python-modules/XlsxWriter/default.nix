{lib, buildPythonPackage, fetchFromGitHub}:

buildPythonPackage rec {

  pname = "XlsxWriter";
  version = "1.2.1";

  # PyPI release tarball doesn't contain tests so let's use GitHub. See:
  # https://github.com/jmcnamara/XlsxWriter/issues/327
  src = fetchFromGitHub{
    owner = "jmcnamara";
    repo = pname;
    rev = "RELEASE_${version}";
    sha256 = "0br8ib9n17dfprfly93mjkhdhpndb7i4g57lwscvp2s69ssql32s";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };

}
