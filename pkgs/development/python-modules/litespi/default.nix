{ lib
, buildPythonPackage
, fetchFromGitHub
, migen
, litex
}:

buildPythonPackage rec {
  pname = "litespi";
  version = "2023.04";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "litespi";
    rev = version;
    hash = "sha256-q4I/ir7cQHAVcG+Qz3Zglk3iUwxzLQrCVZbCPTXugds=";
  };

  propagatedBuildInputs = [ migen litex ];

  pythonImportsCheck = [ "litespi" ];

  doCheck = false;

  meta = with lib; {
    description = "Small footprint and configurable SPI core";
    homepage = "https://github.com/litex-hub/litespi";
    license = licenses.bsd2;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
