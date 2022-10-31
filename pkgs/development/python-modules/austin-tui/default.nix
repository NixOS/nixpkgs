{ lib
, buildPythonPackage

, austin-python
, fetchFromGitHub
, importlib-resources
, lxml
, poetry-core
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "austin-tui";
  version = "1.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p403n1x87";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S8K+Ys1PnFs8/7h1Z013xpEUVCEwVhJdZrEk07k56/M=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "^1.1.0*" "^1.1.0"
  '';

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    austin-python
    importlib-resources
    lxml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonRelaxDeps = [ "importlib-resources" ];

  pythonImportsCheck = [ "austin_tui" ];

  meta = with lib; {
    description = "The top-like text-based user interface for Austin";
    homepage = "https://github.com/P403n1x87/austin-tui";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
  };
}
