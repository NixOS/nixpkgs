{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
, coverage
, ghostscript
, pillow
}:

buildPythonPackage rec {
  pname = "pydyf";
  version = "0.1.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit version;
    pname = "pydyf";
    sha256 = "sha256-Hi9d5IF09QXeAlp9HnzwG73ZQiyoq5RReCvwDuF4YCw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--isort --flake8 --cov --no-cov-on-fail" ""
  '';


  disabledTests =
    [
      "test_transform"
      "test_text"
    ];

  checkInputs = [
    pytestCheckHook
    coverage
    ghostscript
    pillow
  ];

  meta = with lib; {
    homepage = "https://doc.courtbouillon.org/pydyf/stable/";
    description = "Low-level PDF generator written in Python and based on PDF specification 1.7";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprecenth ];
  };
}
