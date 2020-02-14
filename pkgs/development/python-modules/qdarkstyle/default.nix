{ 
  lib
  , fetchPypi
  , buildPythonPackage
  , helpdev
  , qtpy
}:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "2.8";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    sha256 = "0xfllpwnnxdwvfzrrz3b317vb37n5h1x24nzv6zghij4cr5pr5ka";
  };

  propagatedBuildInputs = [ helpdev qtpy ];

  # Checks fail due to Qt
  doCheck = false;

  meta = with lib; {
    description = "A dark stylesheet for Python and Qt applications";
    homepage = https://github.com/ColinDuquesnoy/QDarkStyleSheet;
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
