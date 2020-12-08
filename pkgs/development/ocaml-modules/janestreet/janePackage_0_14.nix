{ lib, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.14.0" }:

{ pname
, version ? defaultVersion
, hash
, minimumOCamlVersion ? "4.08"
, doCheck ? true
, ...}@args:

buildDunePackage (args // {
  useDune2 = true;
  inherit version;

  inherit minimumOCamlVersion;

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = pname;
    rev = "v${version}";
    sha256 = hash;
  };

  inherit doCheck;

  meta.license = lib.licenses.mit;
  meta.homepage = "https://github.com/janestreet/${pname}";
})
