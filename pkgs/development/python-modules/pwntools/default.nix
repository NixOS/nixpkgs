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
  withAlpha ? withAllFeatures,
  withAvr ? withAllFeatures,
  withAmd64 ? withAllFeatures,
  withArm ? withAllFeatures,
  withCris ? withAllFeatures,
  withI386 ? withAllFeatures,
  withIa64 ? withAllFeatures,
  withM68k ? withAllFeatures,
  withMips ? withAllFeatures,
  withMips64 ? withAllFeatures,
  withMsp430 ? withAllFeatures,
  withPowerpc ? withAllFeatures,
  withPowerpc64 ? withAllFeatures,
  withRiscv32 ? withAllFeatures,
  withRiscv64 ? withAllFeatures,
  withS390 ? withAllFeatures,
  withSparc ? withAllFeatures,
  withSparc64 ? withAllFeatures,
  withVax ? withAllFeatures,
}:

let
  debuggerName = lib.strings.getName debugger;
  binutilsList =
    lib.optionals withAarch64 [ pkgsCross.aarch64-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withAlpha [ pkgsCross.alpha.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withAvr [ pkgsCross.avr.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withAmd64 [ pkgsCross.x86_64-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withArm [ pkgsCross.arm-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withCris [ pkgsCross.cris-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withI386 [ pkgsCross.i686-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withIa64 [ pkgsCross.ia64-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withM68k [ pkgsCross.m68k-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withMips [ pkgsCross.mips-linux-gnu.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withMips64 [ pkgsCross.mips64-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withMsp430 [ pkgsCross.msp430.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withPowerpc [ pkgsCross.ppc-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withPowerpc64 [ pkgsCross.ppc64-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withRiscv32 [ pkgsCross.riscv32-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withRiscv64 [ pkgsCross.riscv64-embedded.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withS390 [ pkgsCross.s390.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withSparc [ pkgsCross.sparc.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withSparc64 [ pkgsCross.sparc64.buildPackages.binutils-unwrapped ]
    ++ lib.optionals withVax [ pkgsCross.vax.buildPackages.binutils-unwrapped ];

  binutilsPath = lib.makeBinPath binutilsList;
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
    # Forcefully use the provided debugger as `gdb`.
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
    installShellCompletion --cmd pwn \
      --bash extra/bash_completion.d/pwn \
      --zsh extra/zsh_completion/_pwn
  '';

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
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
