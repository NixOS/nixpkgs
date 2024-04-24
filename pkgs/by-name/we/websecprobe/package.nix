{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "websecprobe";
  version = "0.0.12";
  pyproject = true;

  src = fetchPypi {
    pname = "WebSecProbe";
    inherit version;
    hash = "sha256-RX4tc6JaUVaNx8nidn8eMcbsmbcSY+VZbup6c6P7oOs=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    requests
    tabulate
  ];

  postInstall = ''
    mv $out/bin/WebSecProbe $out/bin/$pname
  '';

  pythonImportsCheck = [
    "WebSecProbe"
  ];

  meta = with lib; {
    description = "Web Security Assessment Tool";
    homepage = "https://github.com/spyboy-productions/WebSecProbe/";
    changelog = "https://github.com/spyboy-productions/WebSecProbe/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "websecprobe";
  };
}
