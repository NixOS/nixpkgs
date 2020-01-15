{lib, buildPythonPackage, fetchFromGitHub}:

buildPythonPackage rec {

  pname = "XlsxWriter";
  version = "1.2.0";

  # PyPI release tarball doesn't contain tests so let's use GitHub. See:
  # https://github.com/jmcnamara/XlsxWriter/issues/327
  src = fetchFromGitHub{
    owner = "jmcnamara";
    repo = pname;
    rev = "RELEASE_${version}";
    sha256 = "0w9ggzi887w4z6i5mz24kcy7qbkd4d7gycqi0dhqgaj9lzxh7jjh";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };

}
