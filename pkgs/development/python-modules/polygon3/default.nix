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

  meta = {
    description = "Polygon is a python package that handles polygonal shapes in 2D";
    homepage = "https://github.com/jraedler/Polygon3";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
