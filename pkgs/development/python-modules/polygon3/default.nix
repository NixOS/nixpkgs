{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "polygon3";

  # The upstream project hasn't had an update since March 2021.  The tip of the
  # master branch is a commit marked "release 3.0.9", but the most recent tag
  # is "3.0.8".  This means (a) there doesn't seem to be much point in
  # regularly checking for updates, and (b) letting buildPythonPackage follow
  # its default behaviour of setting passthru.updateScript to point to
  # nix-update results in it opening a useless pull request like
  # https://github.com/NixOS/nixpkgs/pull/436890
  #
  # nixpkgs-update: no auto update
  version = "3.0.9";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jraedler";
    repo = "Polygon3";
    rev = "7b2091f77741fa1d94251979bc4a4f2676b4d2d1";
    hash = "sha256-jXtjEzjWwMoVgrHWsK8brSN6TQRxIPRjUaRiLBXYLcI=";
  };

  # malloc error on running the tests
  #  python3.10(30620,0x115b74600) malloc: *** error for object 0x10d6db580: pointer being freed was not allocated
  # > python3.10(30620,0x115b74600) malloc: *** set a breakpoint in malloc_error_break to debug
  # > /nix/store/vbi8rnz0k3jyh4h4g16bbkchdd8mnxw7-setuptools-check-hook/nix-support/setup-hook: line 4: 30620 Abort trap: 6           /nix/store/5cxanhipcbfxnrqgw2qsr3zqr4z711bj-python3-3.10.12/bin/python3.10 nix_run_setup test
  doCheck = false;

  meta = {
    description = "Polygon is a python package that handles polygonal shapes in 2D";
    homepage = "https://github.com/jraedler/Polygon3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
