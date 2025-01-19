{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPypi,
  python,
  pythonOlder,
  unicorn,
  unicorn-emu,
  cmake,
  pkg-config,
  cctools,
  darwin,
  pkgs,
}:

let
  unicorn-emu-for-angr = unicorn-emu.overrideAttrs (
    self: super: rec {
      version = "2.0.1.post1";

      src = fetchFromGitHub {
        owner = "unicorn-engine";
        repo = self.pname;
        rev = version;
        hash = "sha256-Jz5C35rwnDz0CXcfcvWjkwScGNQO1uijF7JrtZhM7mI=";
      };
    }
  );

  packageOverrides = self: super: {
    unicorn = (super.unicorn.override { unicorn = unicorn-emu-for-angr; }).overrideAttrs (
      self: super: { patches = [ ./unicorn-support-python3.12.patch ]; }
    );
  };

  overriddenPython = python.override {
    self = overriddenPython;
    inherit packageOverrides;
  };
in
overriddenPython.pkgs.buildPythonPackage rec {
  pname = "angr";
  version = "9.2.137";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr";
    tag = "v${version}";
    hash = "sha256-RIsgE/WE7QEmOIyujLObnpTpUR0GgUbavPmgs9QwakE=";
  };

  build-system = with overriddenPython.pkgs; [
    setuptools
    overriddenPython.pkgs.unicorn # must explicitly reference
  ];

  dependencies = with overriddenPython.pkgs; [
    ailment
    archinfo
    cachetools
    capstone
    cffi
    claripy
    cle
    cppheaderparser
    dpkt
    gitpython
    itanium-demangler
    mulpyplexer
    nampa
    networkx
    progressbar2
    protobuf
    psutil
    pycparser
    pyformlang
    pyvex
    rich
    rpyc
    sortedcontainers
    sqlalchemy
    sympy
    overriddenPython.pkgs.unicorn # must explicitly reference
    unique-log-filter
    pyvex
  ];

  optional-dependencies = {
    AngrDB = with overriddenPython.pkgs; [ sqlalchemy ];
  };

  setupPyBuildFlags = lib.optionals stdenv.hostPlatform.isLinux [
    "--plat-name"
    "linux"
  ];

  # Tests have additional requirements, e.g., pypcode and angr binaries
  # cle is executing the tests with the angr binaries
  doCheck = false;

  pythonImportsCheck = [
    "angr"
    "claripy"
    "cle"
    "pyvex"
    "archinfo"
  ];

  meta = with lib; {
    description = "Powerful and user-friendly binary analysis platform";
    homepage = "https://angr.io/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [
      fab
      scoder12
    ];
  };
}
