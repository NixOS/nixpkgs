{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, poetry-core
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "collections-extended";
  version = "2.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mlenzen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cK13+CQUELKSiLpG747+C+RB5b6luu0mWLLXTT+uGH4=";
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
