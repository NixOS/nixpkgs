{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.12.0" }:

{ pname, version ? defaultVersion, hash, buildInputs ? [], ...}@args:

buildDunePackage (args // {
  inherit version buildInputs;

  minimumOCamlVersion = "4.07";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = hash;
  };

  strictDeps = true;

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/janestreet/${pname}";
  } // args.meta;
})
