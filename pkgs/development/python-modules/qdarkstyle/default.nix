{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "2.6.8";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    sha256 = "18l2ynq2x8jd380nr47xy947c3qdmhv8nnxnan03y5d51azm8yh3";
  };

  # No tests available
  doCheck = false;

  meta = with lib; {
    description = "A dark stylesheet for Python and Qt applications";
    homepage = https://github.com/ColinDuquesnoy/QDarkStyleSheet;
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
