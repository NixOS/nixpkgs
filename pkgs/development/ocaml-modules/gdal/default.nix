{
  buildDunePackage,
  ctypes-foreign,
  fetchurl,
  gdal,
  lib,
}:

buildDunePackage (finalAttrs: {
  pname = "gdal";
  version = "0.11.0";
  src = fetchurl {
    url = "https://github.com/ocaml-gdal/ocaml-gdal/archive/refs/tags/v${finalAttrs.version}.tar.gz";
    hash = "sha256-fW6bX4cv8eW2dsbv0SaeQwRpuPWB0mGzokQVjCaA8Z8=";
  };
  postPatch = ''
    substituteInPlace src/lib.ml \
      --replace-fail '"libgdal.so"' '"${gdal}/lib/libgdal.so"'
  '';

  propagatedBuildInputs = [
    ctypes-foreign
    gdal
  ];

  doCheck = true;

  meta = {
    description = "OCaml GDAL and OGR bindings";
    homepage = "https://github.com/ocaml-gdal/ocaml-gdal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vog ];
  };
})
