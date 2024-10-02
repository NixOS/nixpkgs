{ pkgs, lib }:
let
  vgpkgs = import (pkgs.fetchFromGitHub {
    # required version for stem and ipaddress to work
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "f539a47dabe6fd614179ee7df12d596bdab1dff9";
    sha256 = "sha256-wXhy+5YmZRaUUaZKnuRIfsOdHsPBQq2ewdMFDS2uRsw=";
  }) { };
in
vgpkgs.python2Packages.buildPythonPackage rec {
  pname = "vanguards";
  version = "0.3.1";

  #tries to access the network during the tests, which fails
  doCheck = false;

  src = pkgs.fetchFromGitHub {
    owner = "mikeperry-tor";
    repo = pname;
    rev = "c3961ac40ca0bce67f79bc76021f5817730033b8";
    sha256 = "sha256-y5WwDLn2asYcA5hTl++UVeH5KZ8VRP4sMIjRv9y7GVE=";
  };

  propagatedBuildInputs = with vgpkgs; [
    (python2.withPackages (
      ps: with ps; [
        stem
        ipaddress
      ]
    ))
  ];

  meta = {
    maintainers = with lib.maintainers; [ ForgottenBeast ];
    mainProgram = "vanguards";
    license = lib.licenses.mit;
    description = ''
      Runs alongside tor and interacts with its control port
      in order to protect and alert against guard node attacks on hidden services
    '';
  };

}
