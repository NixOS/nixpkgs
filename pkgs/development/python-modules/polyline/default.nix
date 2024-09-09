{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "polyline";
  version = "2.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frederickjansen";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fbGGfZdme4OiIGNlXG1uVl1xP+rPVI9l5hjHM0gwAsE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov=polyline --cov-report term-missing" ""
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "polyline" ];

  meta = with lib; {
    description = "Python implementation of Google's Encoded Polyline Algorithm Format";
    longDescription = ''
      polyline is a Python implementation of Google's Encoded Polyline Algorithm Format. It is
      essentially a port of https://github.com/mapbox/polyline.
    '';
    homepage = "https://github.com/frederickjansen/polyline";
    changelog = "https://github.com/frederickjansen/polyline/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ersin ];
  };
}
