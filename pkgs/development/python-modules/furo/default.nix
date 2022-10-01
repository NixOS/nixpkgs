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
  version = "2022.9.29";
  format = "wheel";

  disable = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-VZ7heZnA9ScoSB3PaxsM+Ml0PmjF46GMtFp5knR4aak=";
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

  pythonImportsCheck = [
    "furo"
  ];

  meta = with lib; {
    description = "A clean customizable documentation theme for Sphinx";
    homepage = "https://github.com/pradyunsg/furo";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
