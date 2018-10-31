{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig,
  deepin-gettext-tools, go-dbus-factory, go-gir-generator, go-lib,
  alsaLib, glib, gtk3, libcanberra, libgudev, librsvg, poppler,
  pulseaudio, go, deepin }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "dde-api";
  version = "3.5.0";

  goPackagePath = "pkg.deepin.io/dde/api";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1g3s0i5wa6qyv00yksz4r4cy2vhiknq8v0yx7aribvwm3gxf7jw3";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    pkgconfig
    deepin-gettext-tools
    go-dbus-factory
    go-gir-generator
    go-lib
  ];

  buildInputs = [
    alsaLib
    glib
    gtk3
    libcanberra
    libgudev
    librsvg
    poppler
    pulseaudio
  ];

  postPatch = ''
    patchShebangs .
    sed -i -e "s|/var|$bin/var|" Makefile
  '';

  buildPhase = ''
    make -C go/src/${goPackagePath}
  '';

  installPhase = ''
    make install PREFIX="$bin" SYSTEMD_LIB_DIR="$bin/lib" -C go/src/${goPackagePath}
    mkdir -p $out/share
    mv $bin/share/gocode $out/share/go
    remove-references-to -t ${go} $bin/bin/* $bin/lib/deepin-api/*
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Go-lang bindings for dde-daemon";
    homepage = https://github.com/linuxdeepin/dde-api;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
