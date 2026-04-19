{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, rns
, lxmf
, urwid
, qrcode
, msgpack
, pytestCheckHook
}:

buildPythonPackage rec {
  pname   = "nomadnet";
  version = "0.9.9";
  format  = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dl0+L/qmbnc0zFVPTy2tJj94Do9tJEiYeimNKr0pDVw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    rns
    lxmf
    urwid
    qrcode
    msgpack
  ];

  doCheck = false;

  pythonImportsCheck = [ "nomadnet" ];

  meta = with lib; {
    description = "Off-grid, resilient mesh communication with strong encryption";
    homepage    = "https://github.com/markqvist/NomadNet";
    changelog   = "https://github.com/markqvist/NomadNet/releases/tag/${version}";
    license     = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms   = platforms.unix;
    mainProgram = "nomadnet";
  };
}
