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
  version = "2024.08.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pwndbg";
    repo = "pwndbg";
    rev = version;
    hash = "sha256-mpkUEP0GBwOfbbpogupmDvCo8dkbSGy1YtH8T55rX9g=";
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
