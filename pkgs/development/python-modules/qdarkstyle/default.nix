{ lib
, fetchPypi
, buildPythonPackage
, helpdev
, qtpy
}:

buildPythonPackage rec {
  pname = "qdarkstyle";
  version = "2.8.1";

  src = fetchPypi {
    inherit version;
    pname = "QDarkStyle";
    sha256 = "0883vzg35fzpyl1aiijzpfcdfvpq5vi325w0m7xkx7nxplh02fym";
  };

  # No tests available
  doCheck = false;

  propagatedBuildInputs = [ helpdev qtpy ];

  meta = with lib; {
    description = "A dark stylesheet for Python and Qt applications";
    homepage = "https://github.com/ColinDuquesnoy/QDarkStyleSheet";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
