{ lib
, buildPythonPackage
, fetchPypi
, flit
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyphen";
  version = "0.13.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Boc86//WWo/KfCDA49wDJlXH7o3g9VIgXK07V0JlwpM=";
  };

  nativeBuildInputs = [
    flit
  ];

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
