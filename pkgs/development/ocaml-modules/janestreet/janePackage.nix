{ stdenv, fetchFromGitHub, buildDunePackage, defaultVersion ? "0.11.0" }:

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

  meta.license = stdenv.lib.licenses.asl20;
  meta.homepage = "https://github.com/janestreet/${pname}";
})
