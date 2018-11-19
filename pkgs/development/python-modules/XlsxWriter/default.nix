{lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "XlsxWriter";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dmznx6q3b5xkvlqpw4vqinxh5ynzz8i7hlpz9syiff51y56a8mf";
  };

  meta = {
    description = "A Python module for creating Excel XLSX files";
    homepage = https://xlsxwriter.readthedocs.io/;
    maintainers = with lib.maintainers; [ jluttine ];
    license = lib.licenses.bsd2;
  };
}
