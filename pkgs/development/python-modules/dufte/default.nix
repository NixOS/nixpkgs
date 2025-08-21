{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  importlib-metadata,
  matplotlib,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dufte";
  version = "0.2.29";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "dufte";
    rev = "v${version}";
    hash = "sha256:0ccsmpj160xj6w503a948aw8icj55mw9414xnmijmmjvlwhm0p48";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    matplotlib
    numpy
  ]
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc
    ln -s $HOME/.config/matplotlib $HOME/.matplotlib
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dufte" ];

  meta = with lib; {
    description = "Clean matplotlib plots";
    homepage = "https://github.com/nschloe/dufte";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ris ];
  };
}
