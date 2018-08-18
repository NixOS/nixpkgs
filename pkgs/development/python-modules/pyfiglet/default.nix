{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "0.7.5";
  pname = "pyfiglet";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04jy4182hn5xfs6jf432gxclfj1rhssd7bsf0b4gymrjzkhr8qa4";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "FIGlet in pure Python";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
