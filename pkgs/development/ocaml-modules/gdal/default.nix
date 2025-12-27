{
  buildDunePackage,
  ctypes-foreign,
  fetchFromGitHub,
  lib,
  pkgs,
}:

buildDunePackage (finalAttrs: {
  pname = "gdal";
  version = "0.11.0";
  minimalOCamlVersion = "4.03";
  src = fetchFromGitHub {
    owner = "ocaml-gdal";
    repo = "ocaml-gdal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OuoydV5GddHOJ/9h6cBAOpDJu+IQxobR8bULbW+EjB4=";
  };
  postPatch = ''
    substituteInPlace src/lib.ml \
      --replace-fail '"libgdal.so"' '"${pkgs.gdal}/lib/libgdal.so"'
  '';
  propagatedBuildInputs = [
    ctypes-foreign
    pkgs.gdal
  ];
  doCheck = true;
  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "OCaml GDAL and OGR bindings";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vog ];
  };
})
