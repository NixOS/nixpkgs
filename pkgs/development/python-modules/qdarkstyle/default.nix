{ lib
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
    sha256 = "6a967c4b664446f8bed9df12d1032cf68cb54f186bfc9cbfdbbc756bf9a5d475";
  };

  # No tests available
  doCheck = false;

  propagatedBuildInputs = [ helpdev qtpy ];

  meta = with lib; {
    description = "A dark stylesheet for Python and Qt applications";
    homepage = https://github.com/ColinDuquesnoy/QDarkStyleSheet;
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
