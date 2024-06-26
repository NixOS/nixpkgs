{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wireviz";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MBgX7dWOr3SorOJQjVlRGlSvL+A7Lg+gC1UoS3un9rU=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    graphviz
    pillow
    pyyaml
  ];

  pythonImportsCheck = [ "wireviz" ];

  meta = with lib; {
    description = "Easily document cables and wiring harnesses";
    homepage = "https://pypi.org/project/wireviz/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pinpox ];
    mainProgram = "wireviz";
  };
}
