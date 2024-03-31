{ lib
, buildPythonPackage
, fetchFromGitHub
, impacket
, netaddr
, poetry-core
, pypykatz
, pythonOlder
, pythonRelaxDepsHook
, rich
}:

buildPythonPackage rec {
  pname = "lsassy";
  version = "3.1.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Hackndo";
    repo = "lsassy";
    rev = "refs/tags/v${version}";
    hash = "sha256-VGLSVv/+UpgeSTHoOTjEfQSAYfXA3bAI+yKjcKBI1Z4=";
  };

  pythonRelaxDeps = [
    "impacket"
    "netaddr"
    "rich"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    impacket
    netaddr
    pypykatz
    rich
  ];

  # Tests require an active domain controller
  doCheck = false;

  pythonImportsCheck = [
    "lsassy"
  ];

  meta = with lib; {
    description = "Python module to extract data from Local Security Authority Subsystem Service (LSASS)";
    homepage = "https://github.com/Hackndo/lsassy";
    changelog = "https://github.com/Hackndo/lsassy/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "lsassy";
  };
}
