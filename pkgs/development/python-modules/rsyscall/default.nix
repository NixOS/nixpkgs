{ lib
, buildPythonPackage
, cffi
, trio
, typeguard
, pyroute2
, outcome
, nixdeps
, pytestCheckHook
, typing-extensions
, pythonOlder
, fetchPypi
, librsyscall
, nix
, socat
, pkg-config
, openssh
, coreutils
}:

buildPythonPackage rec {
  pname = "rsyscall";
  version = "0.0.3";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wvviglibnkkh332f27hqzjyz7ipbp6h3p845h0x77y1vlsf4gxk";
  };

  buildInputs = [
    cffi
    librsyscall
  ];
  nativeBuildInputs = [
    pkg-config
  ];
  propagatedBuildInputs = [
    trio
    typeguard
    pyroute2
    outcome
    nixdeps
  ];
  # rsyscall uses these to build containers on the fly
  exportReferencesGraph = [
    "nix" nix
    "librsyscall" librsyscall
    "openssh" openssh
    "coreutils" coreutils
  ];

  checkInputs = [
    pytestCheckHook
    typing-extensions
    socat
  ];
  disabledTests = [
    "ssh"    # the build user's login shell is /noshell
    "net"    # /dev/net/tun doesn't exist
    "nix"    # can't use Nix in the build sandbox
    "pgid"   # /proc/sys/kernel/ns_last_pid doesn't exist
    "fuse"   # /dev/fuse doesn't exist
  ];
  # pytestCheckHook runs against the source tree rather than the installed version by default,
  # but we need to test against the installed version because there's a compiled extension.
  preCheck = "cd $out";

  meta = with lib; {
    description = "A library for making system calls remotely, through another process";
    homepage = "https://github.com/catern/rsyscall";
    license = licenses.mit;
    maintainers = with maintainers; [ catern ];
  };
}
