{ lib
, buildPythonPackage
, fetchPypi
, flit
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyphen";
  version = "0.12.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7d3dfc24b6f2178cdb2b1757ace0bd5d222de3e62c28d22ac578c5f22a13e9b";
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
