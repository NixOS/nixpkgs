{
  lib,
  stdenv,
  buildPythonPackage,
  debugger,
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
  pkgsCross,
  withAllFeatures ? false,
  withAarch64 ? withAllFeatures,
  withAvr ? withAllFeatures,
  withAmd64 ? withAllFeatures,
  withArm ? withAllFeatures,
  withI386 ? withAllFeatures,
  withM68k ? withAllFeatures,
  withMsp430 ? withAllFeatures,
  withPowerpc ? withAllFeatures,
  withRiscv32 ? withAllFeatures,
  withRiscv64 ? withAllFeatures,
  withS390 ? withAllFeatures,
}:

let
  debuggerName = lib.strings.getName debugger;
  binutilsList =
    lib.optionals withAarch64 [ pkgsCross.aarch64-embedded.buildPackages.binutils ]
    ++ lib.optionals withAvr [ pkgsCross.avr.buildPackages.binutils ]
    ++ lib.optionals withAmd64 [ pkgsCross.x86_64-embedded.buildPackages.binutils ]
    ++ lib.optionals withArm [ pkgsCross.armhf-embedded.buildPackages.binutils ]
    ++ lib.optionals withI386 [ pkgsCross.i686-embedded.buildPackages.binutils ]
    ++ lib.optionals withM68k [ pkgsCross.m68k.buildPackages.binutils ]
    ++ lib.optionals withMsp430 [ pkgsCross.msp430.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withPowerpc [ pkgsCross.ppc-embedded.buildPackages.binutils ]
    ++ lib.optionals withRiscv32 [ pkgsCross.riscv32-embedded.buildPackages.binutils ]
    ++ lib.optionals withRiscv64 [ pkgsCross.riscv64-embedded.buildPackages.binutils ]
    ++ lib.optionals withS390 [ pkgsCross.s390.buildPackages.binutils ];
  binutilsPath = lib.makeBinPath binutilsList;
in
buildPythonPackage rec {
  pname = "pwntools";
  version = "4.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HVyiU4PsEPtk4o0ULB2Gj5HqHFOpPTUx0wFdgwgo08M=";
  };

  postPatch = ''
    # Upstream hardcoded the check for the command `gdb-multiarch`;
    # Forcefully use the provided debugger, as `gdb` (hence `pwndbg`) is built with multiarch in `nixpkgs`.
    sed -i 's/gdb-multiarch/${debuggerName}/' pwnlib/gdb.py

    # Make sure the binutils paths are searched by the assembler
    substituteInPlace pwnlib/asm.py \
      --replace "environ['PATH']" "(environ['PATH'] + os.pathsep + '${binutilsPath}').strip(os.pathsep)"
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
  ] ++ binutilsList;

  doCheck = false; # no setuptools tests for the package

  postInstall = ''
    installShellCompletion --bash extra/bash_completion.d/shellcraft
  '';

  postFixup = lib.optionalString (!stdenv.isDarwin) ''
    mkdir -p "$out/bin"
    makeWrapper "${debugger}/bin/${debuggerName}" "$out/bin/pwntools-gdb"
  '';

  pythonImportsCheck = [ "pwn" ];

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
