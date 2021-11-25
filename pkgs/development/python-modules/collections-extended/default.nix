{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "collections-extended";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mlenzen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:1qcr1q49a134b122rpldjiim1fsl32gxs5fpj3232nyb05r68haz";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "collections_extended" ];

  meta = with lib; {
    homepage = "https://github.com/mlenzen/collections-extended";
    description = "Extra Python Collections - bags (multisets), setlists (unique list / indexed set), RangeMap and IndexedDict";
    license = licenses.asl20;
    maintainers = with maintainers; [ exarkun ];
  };
}
