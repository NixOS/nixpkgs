{ lib
, stdenv
, buildPythonPackage
, debugger
, fetchPypi
, mako
, packaging
, pysocks
, pygments
, ropgadget
, capstone
, colored-traceback
, paramiko
, pip
, psutil
, pyelftools
, pyserial
, python-dateutil
, requests
, rpyc
, tox
, unicorn
, intervaltree
, installShellFiles
}:

let
  debuggerName = lib.strings.getName debugger;
in
buildPythonPackage rec {
  pname = "pwntools";
  version = "4.11.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7hnjX721t0YzKcJ75R+tEfUI6E9bxMYXUEtI56GDZP0=";
  };

  postPatch = ''
    # Upstream hardcoded the check for the command `gdb-multiarch`;
    # Forcefully use the provided debugger, as `gdb` (hence `pwndbg`) is built with multiarch in `nixpkgs`.
    sed -i 's/gdb-multiarch/${debuggerName}/' pwnlib/gdb.py
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    mako
    packaging
    pysocks
    pygments
    ropgadget
    capstone
    colored-traceback
    paramiko
    pip
    psutil
    pyelftools
    pyserial
    python-dateutil
    requests
    rpyc
    tox
    unicorn
    intervaltree
  ];

  doCheck = false; # no setuptools tests for the package

  postInstall = ''
    installShellCompletion --bash extra/bash_completion.d/shellcraft
  '';

  postFixup = lib.optionalString (!stdenv.isDarwin) ''
    mkdir -p "$out/bin"
    makeWrapper "${debugger}/bin/${debuggerName}" "$out/bin/pwntools-gdb"
  '';

  meta = with lib; {
    description = "CTF framework and exploit development library";
    homepage = "https://pwntools.com";
    changelog = "https://github.com/Gallopsled/pwntools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r pamplemousse ];
  };
}
