{ callPackage
, paramiko
, cma
}:

callPackage ./common.nix {
  propagatedBuildInputs = [
    paramiko
    cma
  ];
} "client"
