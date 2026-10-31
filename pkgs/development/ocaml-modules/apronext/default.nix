{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  apron,
}:

buildDunePackage (finalAttrs: {
  pname = "apronext";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "ghilesZ";
    repo = "apronext";
    rev = "39610de5930e12c8d0156ed2d55fedc220f1e77d";
    hash = "sha256-K19hmvyI1RJlKv24VJustDfkGTdrW4PcR8xif/y/giQ=";
  };

  propagatedBuildInputs = [ apron ];

  meta = {
    license = lib.licenses.asl20;
    homepage = "https://github.com/ghilesZ/apronext";
    description = "Extension for the OCaml interface of the apron library";
  };

})
