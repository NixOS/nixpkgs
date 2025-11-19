{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  impacket,
  netaddr,
  poetry-core,
  pypykatz,
  rich,
}:

buildPythonPackage rec {
  pname = "lsassy";
  version = "3.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = "lsassy";
    tag = "v${version}";
    hash = "sha256-cQfyRCZv0ZTaj7Ay7zTzFnU7PQluP3VweeFof8+W70M=";
  };

  pythonRelaxDeps = [
    "impacket"
    "netaddr"
    "rich"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    impacket
    netaddr
    pypykatz
    rich
  ];

  # Tests require an active domain controller
  doCheck = false;

  pythonImportsCheck = [ "lsassy" ];

  meta = with lib; {
    description = "Python module to extract data from Local Security Authority Subsystem Service (LSASS)";
    homepage = "https://github.com/Hackndo/lsassy";
    changelog = "https://github.com/Hackndo/lsassy/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "lsassy";
  };
}
