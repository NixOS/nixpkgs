{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.15.0" }:

{ pname
, version ? defaultVersion
, hash
, minimumOCamlVersion ? "4.11"
, doCheck ? true
, buildInputs ? []
, ...}@args:

buildDunePackage (args // {
  useDune2 = true;
  inherit version buildInputs;

  inherit minimumOCamlVersion;

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = hash;
  };

  inherit doCheck;

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/janestreet/${pname}";
  } // args.meta;
})
