{
  lib,
  callPackage,
  symlinkJoin,
  buildPythonPackage,
  fetchPypi,
  capstone,
  colored-traceback,
  intervaltree,
  mako,
  packaging,
  paramiko,
  psutil,
  pyelftools,
  pygments,
  pyserial,
  pysocks,
  python-dateutil,
  requests,
  ropgadget,
  rpyc,
  setuptools,
  six,
  sortedcontainers,
  unicorn,
  unix-ar,
  zstandard,
  installShellFiles,
  pwndbg,
  gdb,
  runCommandNoCC,
}:

let
  binutilsArchs = [
    "aarch64"
    "alpha"
    "arm"
    "avr"
    "cris"
    "hppa"
    "ia64"
    "m68k"
    "mips"
    "mips64"
    "msp430"
    "powerpc"
    "powerpc64"
    "s390"
    "sparc"
    "vax"
    "xscale"
    "i386"
    "x86_64"
  ];
  binutilsPackages = lib.attrsets.genAttrs binutilsArchs (
    targetArch: callPackage ./binutils.nix { inherit targetArch; }
  );
  binutilsAll = symlinkJoin {
    name = "binutils-cross-all";
    paths = builtins.attrValues binutilsPackages;
  };
  wrap-debugger =
    pkg: path:
    runCommandNoCC (lib.strings.getName pkg + "-wrapped") { } ''
      mkdir -p $out/bin
      ln -s ${pkg}/bin/${path} $out/bin/pwntools-gdb
    '';
in

buildPythonPackage rec {
  pname = "pwntools";
  version = "4.14.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g7MkfeCD3/r6w79A9NFFVzLxbiXOMQX9CbVawPDRLoM=";
  };

  postPatch = ''
    # Upstream hardcoded the check for the command `gdb-multiarch`;
    # However `gdb` and `pwndbg` is already built with multiarch support.
    # Here we change name it looks for to `pwntools-gdb` and which matches
    # the name set by the `wrap-debugger` function.
    sed -i 's/gdb-multiarch/pwntools-gdb/' pwnlib/gdb.py
  '';

  nativeBuildInputs = [ installShellFiles ];

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "pip" ];

  propagatedBuildInputs = [
    capstone
    colored-traceback
    intervaltree
    mako
    packaging
    paramiko
    psutil
    pyelftools
    pygments
    pyserial
    pysocks
    python-dateutil
    requests
    ropgadget
    rpyc
    six
    sortedcontainers
    unicorn
    unix-ar
    zstandard
  ];

  doCheck = false; # no setuptools tests for the package

  postInstall = ''
    installShellCompletion --bash extra/bash_completion.d/shellcraft
  '';

  pythonImportsCheck = [ "pwn" ];

  passthru.binutils = binutilsPackages // {
    "all" = binutilsAll;
  };
  passthru.debugger = {
    inherit wrap-debugger;
    gdb = wrap-debugger gdb "gdb";
    pwndbg = wrap-debugger pwndbg "pwndbg";
  };

  meta = with lib; {
    description = "CTF framework and exploit development library";
    homepage = "https://pwntools.com";
    changelog = "https://github.com/Gallopsled/pwntools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      bennofs
      kristoff3r
      pamplemousse
    ];
  };
}
