{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dufte";
  version = "0.2.29";
  pyproject = true;

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
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.config/matplotlib
    echo "backend: ps" > $HOME/.config/matplotlib/matplotlibrc
    ln -s $HOME/.config/matplotlib $HOME/.matplotlib
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dufte" ];

  meta = {
    description = "Clean matplotlib plots";
    homepage = "https://github.com/nschloe/dufte";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ris ];
  };
}
