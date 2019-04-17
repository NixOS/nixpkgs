{ stdenv, lib, fetchurl, buildDunePackage
, pkgconfig, cairo
}:

buildDunePackage rec {
  pname = "cairo2";
  version = "0.6";

  src = fetchurl {
    url = "https://github.com/Chris00/ocaml-cairo/releases/download/${version}/cairo2-${version}.tbz";
    sha256 = "1k2q7ipmddqnd2clybj4qb5xwzzrnl2fxnd6kv60dlzgya18lchs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cairo ];

  doCheck = !stdenv.isDarwin;

  meta = {
    homepage = "https://github.com/Chris00/ocaml-cairo";
    description = "Binding to Cairo, a 2D Vector Graphics Library";
    longDescription = ''
      This is a binding to Cairo, a 2D graphics library with support for
      multiple output devices. Currently supported output targets include
      the X Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.
    '';
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ jirkamarsik vbgl ];
  };
}
