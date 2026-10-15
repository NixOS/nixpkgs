{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  glib,
  gst_all_1,
}:

buildDunePackage (finalAttrs: {
  pname = "gstreamer";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-gstreamer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UUp0qfp+XKasF8ZUSG3tWXqqE3TS2GXSzJA0CnCIHXk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    glib.dev
    gst_all_1.gstreamer.dev
    gst_all_1.gst-plugins-base
  ];

  env.CFLAGS_COMPILE = toString [
    "-I${glib.dev}/include/glib-2.0"
    "-I${glib.out}/lib/glib-2.0/include"
    "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
    "-I${gst_all_1.gstreamer.dev}/include/gstreamer-1.0"
  ];

  meta = {
    homepage = "https://github.com/savonet/ocaml-gstreamer";
    description = "Bindings for the GStreamer library which provides functions for playning and manipulating multimedia streams";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
