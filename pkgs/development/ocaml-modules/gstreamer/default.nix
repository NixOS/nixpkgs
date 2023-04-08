{ lib, stdenv, buildDunePackage, fetchFromGitHub, dune-configurator, AppKit, Foundation, pkg-config, glib, gst_all_1 }:

buildDunePackage rec {
  pname = "gstreamer";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-gstreamer";
    rev = "v${version}";
    sha256 = "0y8xi1q0ld4hrk96bn6jfh9slyjrxmnlhm662ynacp3yzalp8jji";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ] ++ lib.optionals stdenv.isDarwin [ AppKit Foundation ];
  propagatedBuildInputs = [ glib.dev gst_all_1.gstreamer.dev gst_all_1.gst-plugins-base ];

  CFLAGS_COMPILE = [
    "-I${glib.dev}/include/glib-2.0"
    "-I${glib.out}/lib/glib-2.0/include"
    "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
    "-I${gst_all_1.gstreamer.dev}/include/gstreamer-1.0"
  ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-gstreamer";
    description = "Bindings for the GStreamer library which provides functions for playning and manipulating multimedia streams";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
