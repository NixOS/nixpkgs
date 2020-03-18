{ stdenv, buildPythonPackage, fetchPypi, joblib, matplotlib, decorator, scipy }:

buildPythonPackage rec {
  pname = "music21";
  version = "5.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "360d977254c4c024da6cffbf7d4fb1ca36ba36ee516b1719a80e7141299bc8a6";
  };

  propagatedBuildInputs = [ joblib matplotlib decorator scipy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Toolkit for Computer-Aided Musical Analysis.";
    homepage = "https://github.com/cuthbertLab/music21";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jmorag ];
  };
}
