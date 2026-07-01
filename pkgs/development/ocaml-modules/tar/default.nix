{
  lib,
  fetchurl,
  buildDunePackage,
  decompress,
}:

buildDunePackage (finalAttrs: {
  pname = "tar";
  version = "3.5.0";
  src = fetchurl {
    url = "https://github.com/mirage/ocaml-tar/releases/download/v${finalAttrs.version}/tar-${finalAttrs.version}.tbz";
    hash = "sha256-haKmHTDu+B5L+B4LQp0hPOtd1urtzWDJeeHLuRFJ+Qw=";
  };

  propagatedBuildInputs = [
    decompress
  ];

  doCheck = true;

  meta = {
    description = "Decode and encode tar format files in pure OCaml";
    homepage = "https://github.com/mirage/ocaml-tar";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
})
