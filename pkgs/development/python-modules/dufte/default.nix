{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pythonOlder
, importlib-metadata
, matplotlib
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dufte";
  version = "0.2.12";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ag1d7h1wijkc7v2vpgkbqjlnpiwd4nh8zhxiby0989bpmlp3jr3";
  };
  format = "pyproject";

  propagatedBuildInputs = [
    matplotlib
    numpy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  preCheck = ''
    export HOME=$TMPDIR
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "dufte" ];
  pytestFlagsArray = [
    # we don't have the "exdown" package (yet)
    "--ignore=test/test_readme.py"
  ];

  meta = with lib; {
    description = "Clean matplotlib plots";
    homepage = "https://github.com/nschloe/dufte";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ris ];
  };
}
