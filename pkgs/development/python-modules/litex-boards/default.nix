{ lib
, buildPythonPackage
, fetchFromGitHub
, migen
, litex
}:

buildPythonPackage rec {
  pname = "litex-boards";
  version = "2023.04";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "litex-hub";
    repo = "litex-boards";
    rev = version;
    hash = "sha256-4gG3vvqnVXNfB7FtOeI9EPD/E8biREM5WKuYnSSBELc=";
  };

  # VexRiscV CPU is needed.
  nativeCheckInputs = [ migen litex ];

  pythonImportsCheck = [ "litex_boards" ];

  doCheck = false;

  meta = with lib; {
    description = "LiteX boards files";
    homepage = "https://github.com/litex-hub/litex-boards";
    license = licenses.bsd2;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
