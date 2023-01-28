{ lib
, buildPythonPackage
, fetchPypi
, flit
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyphen";
  version = "0.13.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hH9XoEOlhAjyRnCuAYT/bt+1/VcxdDIIIowCjdxRRDg=";
  };

  nativeBuildInputs = [
    flit
  ];

  preCheck = ''
    sed -i '/addopts/d' pyproject.toml
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pyphen"
  ];

  meta = with lib; {
    description = "Module to hyphenate text";
    homepage = "https://github.com/Kozea/Pyphen";
    changelog = "https://github.com/Kozea/Pyphen/releases/tag/${version}";
    license = with licenses; [gpl2 lgpl21 mpl20];
    maintainers = with maintainers; [ rvl ];
  };
}
