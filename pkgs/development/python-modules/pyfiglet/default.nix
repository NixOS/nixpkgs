{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.8.post0";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kjskfbkm28rajcj0aa0v5w1v4p6r9y0hlhzz2bwsxvwlqg4b519";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "FIGlet in pure Python";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
