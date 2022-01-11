{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyphen";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2c3ed82c3a04317df5102addafe89652b0876bc6c6265f5dd4c3efaf02315e8";
  };

  preCheck = ''
    sed -i '/addopts/d' pyproject.toml
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Pure Python module to hyphenate text";
    homepage = "https://github.com/Kozea/Pyphen";
    license = with licenses; [gpl2 lgpl21 mpl20];
    maintainers = with maintainers; [ rvl ];
  };
}
