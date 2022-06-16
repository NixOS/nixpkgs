{ stdenv
, gdk-pixbuf
, pkg-config
, meson
, ninja
, outputColor ? "#ffffff"
}:
stdenv.mkDerivation {
  name = "gdk-pixbuf-test-loader";
  src = ./test-loader;
  buildInputs = [gdk-pixbuf];
  nativeBuildInputs = [pkg-config meson ninja];
  postInstall = ''
    mkdir -p $(dirname $out/${gdk-pixbuf.cacheFile})
    ${gdk-pixbuf.dev}/bin/gdk-pixbuf-query-loaders $out/lib/libtest_loader.so > $out/${gdk-pixbuf.cacheFile}
  '';
  mesonFlags = ["-DoutputColor=${outputColor}"];
}