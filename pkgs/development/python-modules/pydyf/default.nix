{ lib
, buildPythonPackage
, fetchpatch
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

  patches = [
    # Fix tests for Ghostscript 9.56
    # Remove after v0.1.3 has been released
    (fetchpatch {
      url = "https://github.com/CourtBouillon/pydyf/commit/d4c34823f1d15368753c9c26f7acc7a24fc2d979.patch";
      sha256 = "sha256-2hHZW/q5CbStbpSJYbm3b23qKXANEb5jbPGQ83uHC+Q=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--isort --flake8 --cov --no-cov-on-fail" ""
  '';

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
