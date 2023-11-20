{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pythonRelaxDepsHook
, sphinx
, beautifulsoup4
, sphinx-basic-ng
}:

buildPythonPackage rec {
  pname = "furo";
  version = "2023.7.26";
  format = "wheel";

  disable = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-HHk2kp7FfF3ezHyF8H+oss5Ta1yJE3dkzKUIvpDhHv0=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "sphinx"
  ];

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
    changelog = "https://github.com/pradyunsg/furo/blob/${version}/docs/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ Luflosi ];
  };
}
