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
let
  # Fixes an issue when disassembling syscalls. Upstream also uses the beta
  # version. See https://github.com/pwndbg/pwndbg/issues/2500.
  pwntools-beta = pwntools.overrideAttrs (oldAttrs: rec {
    version = "4.14.0beta1";
    src = fetchFromGitHub {
      owner = "Gallopsled";
      repo = "pwntools";
      rev = version;
      sha256 = "sha256-hZ8wK5HtIKm3CbNpi6+q28H4YGzAL+34MI6b+YPLzzs=";
    };
  });
in
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
    pwntools-beta
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
