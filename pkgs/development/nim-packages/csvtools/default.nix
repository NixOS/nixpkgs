{ lib, pkgs, buildNimPackage, fetchFromGitHub }:

buildNimPackage (finalAttrs: {
  pname = "csvtools";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "andreaferretti";
    repo = "csvtools";
    rev = "${finalAttrs.version}";
    hash = "sha256-G/OvcusnlRR5zdGF+wC7z411RLXI6D9aFJVj9LrMR+s=";
  };
  doCheck = true;
  meta = finalAttrs.src.meta // {
    description = "Manage CSV files easily in Nim";
    homepage = "https://github.com/andreaferretti/csvtools";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.trevdev ];
  };
})
