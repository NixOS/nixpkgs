{ lib
, buildPythonPackage
, fetchPypi
, flit
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyphen";
  version = "0.13.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hH9XoEOlhAjyRnCuAYT/bt+1/VcxdDIIIowCjdxRRDg=";
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
