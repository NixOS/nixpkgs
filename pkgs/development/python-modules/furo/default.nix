{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, sphinx
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "furo";
  version = "2022.3.4";
  format = "wheel";
  disable = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    sha256 = "sha256-bHGCk+v4d1XwufFIseaXyeOqvXr5VWRNS8ruXOddt4E=";
  };

  propagatedBuildInputs = [
    sphinx
    beautifulsoup4
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
