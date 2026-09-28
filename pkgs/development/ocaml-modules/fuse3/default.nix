{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  camlidl,
  dune-configurator,
  pkg-config,
  fuse3,
}:

buildDunePackage (finalAttrs: {
  pname = "fuse3";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "ocamlfuse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xy3Jf4GTQP3vM6vRxBAeOIASWRuoNdlbt91eCco2zMg=";
  };

  nativeBuildInputs = [
    camlidl
    pkg-config
  ];

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    camlidl
    fuse3
  ];

  meta = {
    description = "OCaml bindings for libfuse 3";
    homepage = "https://github.com/astrada/ocamlfuse/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
