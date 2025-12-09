{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  defaultVersion ? "0.17.0",
}:

{
  pname,
  version ? defaultVersion,
  hash,
  minimalOCamlVersion ? "5.1",
  doCheck ? true,
  buildInputs ? [ ],
  ...
}@args:

buildDunePackage (
  args
  // {
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
    }
    // args.meta;
  }
)
