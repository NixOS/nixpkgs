{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "kitchen";
  version = "1.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "af9fbb60f68cbdb2ead402beb8fa7c7edadbe2aa7b5a70138b7c4b0fa88153fd";
  };

  meta = with stdenv.lib; {
    description = "Kitchen contains a cornucopia of useful code";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
  };
}
