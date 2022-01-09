{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-cov
, pytest-isort
, setuptools-scm
}:

buildPythonPackage {
  pname = "dictdiffer";
  version = "0.9.0";

  src = fetchPypi {
    pname = "dictdiffer";
    version = "0.9.0";
    sha256 = "sha256-F7rPX7/mE8zxttUSvXZuayH7eYgioTOqhgmLismZdXg=";
  };


  # dictdiffer requires pytest-py{code|doc}style package to be installed, skipping doesn't
  # affect correctness of built package.
  # We shouldn't need pytest-runner to build or install the package given that
  # we are using pytestCheckHook
  postPatch = ''
    sed -e "s/--pycodestyle//" -i pytest.ini
    sed -e "s/--pydocstyle//" -i pytest.ini
    sed -e "/pytest-runner/d" -i setup.py
  '';

  buildInputs = [ setuptools-scm ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-isort
  ];

  meta = with lib; {
    homepage = "https://github.com/inveniosoftware/dictdiffer";
    description = "A helper module that helps you to diff and patch dictionaries";
    license = licenses.mit;
    maintainers = with maintainers; [ davidwilemski ];
  };
}

