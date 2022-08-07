{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, beautifulsoup4
, sphinx-basic-ng
}:

buildPythonPackage rec {
  pname = "furo";
  version = "2022.6.21";
  format = "wheel";
  disable = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    sha256 = "sha256-Bhto4yM0Xif8ugJM8zoed/Pf2NmYdBC+gidJpwbirdY=";
  };

  propagatedBuildInputs = [
    sphinx
    beautifulsoup4
    sphinx-basic-ng
  ];

  installCheckPhase = ''
    # furo was built incorrectly if this directory is empty
    # Ignore the hidden file .gitignore
    cd "$out/lib/python"*
    if [ "$(ls 'site-packages/furo/theme/furo/static/' | wc -l)" -le 0 ]; then
      echo 'static directory must not be empty'
      exit 1
    fi
    cd -
  '';

  pythonImportsCheck = [ "furo" ];

  meta = with lib; {
    description = "A clean customizable documentation theme for Sphinx";
    homepage = "https://github.com/pradyunsg/furo";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
