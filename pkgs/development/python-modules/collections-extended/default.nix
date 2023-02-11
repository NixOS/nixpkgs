{ lib
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, poetry-core
, pytestCheckHook
, pythonOlder
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
    hash = "sha256-cK13+CQUELKSiLpG747+C+RB5b6luu0mWLLXTT+uGH4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "collections_extended"
  ];

  meta = with lib; {
    description = "Extra Python Collections - bags (multisets), setlists (unique list/indexed set), RangeMap and IndexedDict";
    homepage = "https://github.com/mlenzen/collections-extended";
    license = licenses.asl20;
    maintainers = with maintainers; [ exarkun ];
  };
}
