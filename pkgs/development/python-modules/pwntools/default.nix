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
  version = "4.14.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YPBJdtFyISDRi51QVTQIoCRmS1z4iPNvJYr8pL8DXKw=";
  };

  postPatch = ''
    # Upstream hardcoded the check for the command `gdb-multiarch`;
    # Forcefully use the provided debugger as `gdb`.
    sed -i 's/gdb-multiarch/${debuggerName}/' pwnlib/gdb.py

    # Disable update checks
    substituteInPlace pwnlib/update.py \
      --replace-fail 'disabled        = False' 'disabled        = True'
  '';

  nativeBuildInputs = [ installShellFiles ];

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    "pip"
    "unicorn"
  ];

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
