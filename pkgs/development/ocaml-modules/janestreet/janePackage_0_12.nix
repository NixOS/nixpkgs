{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.12.0" }:

{ pname, version ? defaultVersion, hash, ...}@args:

buildDunePackage (args // {
  inherit version;

  useDune2 = false;

  minimalOCamlVersion = "4.07";

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
