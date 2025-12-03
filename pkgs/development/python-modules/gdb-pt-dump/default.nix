{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage {
  pname = "gdb-pt-dump";
  version = "0-unstable-2024-04-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martinradev";
    repo = "gdb-pt-dump";
    rev = "50227bda0b6332e94027f811a15879588de6d5cb";
    hash = "sha256-yiP3KY1oDwhy9DmNQEht/ryys9vpgkFS+EJcSA6R+cI=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "pt" ];

  meta = with lib; {
    description = "GDB script to enhance debugging of a QEMU-based virtual machine";
    homepage = "https://github.com/martinradev/gdb-pt-dump";
    license = licenses.mit;
    maintainers = with maintainers; [ msanft ];
  };
}
