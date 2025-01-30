{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  capstone,
  future,
  ipython,
  psutil,
  pwntools,
  pycparser,
  pyelftools,
  pygments,
  requests,
  rpyc,
  sortedcontainers,
  tabulate,
  typing-extensions,
  unicorn,
  gdb-pt-dump,
  poetry-core,
}:
buildPythonPackage rec {
  pname = "pwndbg";
  version = "2025.01.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    tag = version;
    hash = "sha256-2aoyB+B9qs2/L+KbCxsiGnha+WCJdm/AGmwEr5zB/0E=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    capstone
    future
    ipython
    psutil
    pwntools
    pycparser
    pyelftools
    pygments
    requests
    rpyc
    sortedcontainers
    tabulate
    typing-extensions
    unicorn
    gdb-pt-dump
  ];

  meta = {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    homepage = "https://pwndbg.re";
    changelog = "https://github.com/pwndbg/pwndbg/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ msanft ];
  };
}
