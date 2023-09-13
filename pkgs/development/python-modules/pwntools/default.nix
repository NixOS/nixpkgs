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
<<<<<<< HEAD
  pname = "pwntools";
  version = "4.10.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WI6J6meFJ8C1tsru7n524xNS544vHPPdp7yaz1JuRG0=";
  };

  postPatch = ''
=======
  version = "4.9.0";
  pname = "pwntools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7qZ9GC+RcEiDkpmNmy8d67dYiTgFBVAfB3B2RfrH5xI=";
  };

  postPatch = ''
    # Upstream has set an upper bound on unicorn because of https://github.com/Gallopsled/pwntools/issues/1538,
    # but since that is a niche use case and it requires extra work to get unicorn 1.0.2rc3 to work we relax
    # the bound here. Check if this is still necessary when updating!
    sed -i 's/unicorn>=1.0.2rc1,<1.0.2rc4/unicorn>=1.0.2rc1/' setup.py

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    description = "CTF framework and exploit development library";
    homepage = "https://pwntools.com";
    changelog = "https://github.com/Gallopsled/pwntools/releases/tag/${version}";
=======
    homepage = "https://pwntools.com";
    description = "CTF framework and exploit development library";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ bennofs kristoff3r pamplemousse ];
  };
}
