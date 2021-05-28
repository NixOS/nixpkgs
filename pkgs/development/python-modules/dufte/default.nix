{ stdenv
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
  version = "0.2.9";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nkaczipbsm8c14j9svxry2wigmn5iharibb6b8g062sjaph8x17";
  };
  format = "pyproject";

  propagatedBuildInputs = [
    matplotlib
    numpy
  ] ++ stdenv.lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  preCheck = ''
    export HOME=$TMPDIR
    mkdir -p $HOME/.matplotlib
    echo "backend: ps" > $HOME/.matplotlib/matplotlibrc
  '';
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "dufte" ];

  meta = with stdenv.lib; {
    description = "Clean matplotlib plots";
    homepage = "https://github.com/nschloe/dufte";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ris ];
  };
}
