{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.11.0" }:

{ pname, version ? defaultVersion, hash, buildInputs ? [], ...}@args:

buildDunePackage (args // {
  inherit version buildInputs;

  useDune2 = false;

  minimalOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = hash;
  };

  strictDeps = true;

  meta = {
    license = lib.licenses.asl20;
    homepage = "https://github.com/janestreet/${pname}";
  } // args.meta;
})
