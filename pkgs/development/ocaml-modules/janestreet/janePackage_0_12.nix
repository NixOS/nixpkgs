{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  defaultVersion ? "0.12.0",
}:

{
  pname,
  version ? defaultVersion,
  duneVersion ? "3",
  hash,
  ...
}@args:

buildDunePackage (
  args
  // {
    inherit version duneVersion;

    minimalOCamlVersion = "4.07";

    src = fetchFromGitHub {
      owner = "janestreet";
      repo = pname;
      rev = "v${version}";
      sha256 = hash;
    };

    meta = {
      license = lib.licenses.mit;
      homepage = "https://github.com/janestreet/${pname}";
    }
    // args.meta;
  }
)
