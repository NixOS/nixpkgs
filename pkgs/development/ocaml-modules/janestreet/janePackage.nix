{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.11.0" }:

{ pname, version ? defaultVersion, hash, ...}@args:

buildDunePackage (args // {
  inherit version;

  minimumOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = hash;
  };

  meta = {
    license = lib.licenses.asl20;
    homepage = "https://github.com/janestreet/${pname}";
  } // args.meta;
})
