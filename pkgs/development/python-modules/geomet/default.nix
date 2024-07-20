{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  click,
  setuptools,
  six,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "geomet";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "geomet";
    repo = "geomet";
    rev = "refs/tags/${version}";
    hash = "sha256-YfI29925nffzRBMJb6Gm3muvlpwP3zSw2YJ2vWcf+Bo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    click
    six
  ];

  pythonImportsCheck = [ "geomet" ];

  meta = with lib; {
    description = "Convert GeoJSON to WKT/WKB (Well-Known Text/Binary) and vice versa";
    mainProgram = "geomet";
    homepage = "https://github.com/geomet/geomet";
    changelog = "https://github.com/geomet/geomet/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      turion
      ris
    ];
  };
}
