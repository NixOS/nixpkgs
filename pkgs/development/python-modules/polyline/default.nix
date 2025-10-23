{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "polyline";
  version = "2.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frederickjansen";
    repo = "polyline";
    tag = "v${version}";
    hash = "sha256-HUdjebUMcYGW+7dyOpVgBnBcesmqDWpw1NgYigOxmQ8=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "polyline" ];

  meta = with lib; {
    description = "Python implementation of Google's Encoded Polyline Algorithm Format";
    longDescription = ''
      polyline is a Python implementation of Google's Encoded Polyline Algorithm Format. It is
      essentially a port of https://github.com/mapbox/polyline.
    '';
    homepage = "https://github.com/frederickjansen/polyline";
    changelog = "https://github.com/frederickjansen/polyline/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ ersin ];
  };
}
