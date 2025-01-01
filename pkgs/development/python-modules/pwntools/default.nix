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
}:

let
  debuggerName = lib.strings.getName debugger;
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
