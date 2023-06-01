{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.14.0" }:

{ pname
, version ? defaultVersion
, hash
, minimalOCamlVersion ? "4.08"
, doCheck ? true
, buildInputs ? []
, ...}@args:

buildDunePackage (args // {
  duneVersion = "3";
  inherit version buildInputs;

  inherit minimalOCamlVersion;

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
