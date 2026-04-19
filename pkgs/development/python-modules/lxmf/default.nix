{ lib
, buildPythonPackage
, fetchurl
, rns
, pytestCheckHook
}:

buildPythonPackage rec {
  pname   = "lxmf";
  version = "0.9.4";
  format  = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/3b/b1/1f06fdfe6e6366781625802102b77180645fc9c04a358bc899ace7a07e31/lxmf-0.9.4-py3-none-any.whl";
    hash = "sha256-ct66zoAd7IsshB7jR1/ONrewDqjiWYIuFVV9393B5GQ=";
  };

  propagatedBuildInputs = [ rns ];

  doCheck = false;

  pythonImportsCheck = [ "LXMF" ];

  meta = with lib; {
    description = "Lightweight Extensible Message Format over Reticulum";
    homepage    = "https://github.com/markqvist/LXMF";
    changelog   = "https://github.com/markqvist/LXMF/releases/tag/${version}";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms   = platforms.unix;
  };
}
