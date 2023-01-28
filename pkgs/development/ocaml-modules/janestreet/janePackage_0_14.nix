{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.14.0" }:

{ pname
, version ? defaultVersion
, hash
, minimumOCamlVersion ? "4.08"
, doCheck ? true
, buildInputs ? []
, strictDeps ? true
, ...}@args:

buildDunePackage (args // {
  useDune2 = true;
  inherit version buildInputs strictDeps;

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
