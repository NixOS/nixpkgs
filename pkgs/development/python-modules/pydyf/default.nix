{ lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pytestCheckHook,
  coverage,
  ghostscript,
  pillow,
  pytest,
  pytest-cov,
  pytest-flake8,
  pytest-isort
}:

buildPythonPackage rec {
  pname = "pydyf";
  version = "0.1.2";
  disabled = !isPy3k;

  pytestFlagsArray = [
    # setup.py is auto-generated and doesn't pass the flake8 check
    "--ignore=setup.py"
  ];

  checkInputs = [
    pytestCheckHook
    coverage
    ghostscript
    pillow
    pytest
    pytest-cov
    pytest-flake8
    pytest-isort
  ];

  src = fetchPypi {
    inherit version;
    pname = "pydyf";
    sha256 = "sha256-Hi9d5IF09QXeAlp9HnzwG73ZQiyoq5RReCvwDuF4YCw=";
  };

  meta = with lib; {
    homepage = "https://doc.courtbouillon.org/pydyf/stable/";
    description = "Low-level PDF generator written in Python and based on PDF specification 1.7";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprecenth ];
  };
}
