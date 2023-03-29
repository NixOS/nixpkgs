{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.14.0" }:

{ pname
, version ? defaultVersion
, hash
, minimumOCamlVersion ? "4.08"
, doCheck ? true
, buildInputs ? []
, ...}@args:

buildDunePackage (args // {
  inherit version buildInputs;

  inherit minimumOCamlVersion;

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = hash;
  };

  duneVersion = "3";

  inherit doCheck;

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/janestreet/${pname}";
  } // args.meta;
})
