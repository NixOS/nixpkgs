{ lib
, stdenv
, buildPythonPackage
, debugger
, fetchPypi
, Mako
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
  version = "4.8.0";
  pname = "pwntools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QgUuLYg3EOTh2gQekWdabXGftOXvLdJFyyhT2hEmkpA=";
  };

  postPatch = ''
    # Upstream has set an upper bound on unicorn because of https://github.com/Gallopsled/pwntools/issues/1538,
    # but since that is a niche use case and it requires extra work to get unicorn 1.0.2rc3 to work we relax
    # the bound here. Check if this is still necessary when updating!
    sed -i 's/unicorn>=1.0.2rc1,<1.0.2rc4/unicorn>=1.0.2rc1/' setup.py

    # Upstream hardcoded the check for the command `gdb-multiarch`;
    # Forcefully use the provided debugger, as `gdb` (hence `pwndbg`) is built with multiarch in `nixpkgs`.
    sed -i 's/gdb-multiarch/${debuggerName}/' pwnlib/gdb.py
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    Mako
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
    homepage = "http://pwntools.com";
    description = "CTF framework and exploit development library";
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r pamplemousse ];
  };
}
