{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "wireviz";
  version = "0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lFJG0jkE42h2boCxDzXfWPmKFc2Ycqx598wPhD/jaLM=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    graphviz
    pillow
    pyyaml
  ];

  pythonImportsCheck = [
    "wireviz"
    "wireviz.wireviz"
    "wireviz.wv_cli"
  ];

  meta = with lib; {
    description = "Easily document cables and wiring harnesses";
    homepage = "https://pypi.org/project/wireviz/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pinpox ];
    mainProgram = "wireviz";
  };
}
