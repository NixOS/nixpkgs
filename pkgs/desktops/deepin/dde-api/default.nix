{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig,
go-gir-generator, glib, gtk3, poppler, librsvg, pulseaudio, alsaLib,
libcanberra, gnome3, deepin-gettext-tools, go }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "dde-api";
  version = "3.1.30";

  goPackagePath = "pkg.deepin.io/dde/api";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0piw6ka2xcbd5vi7m33d1afdjbb7nycxvmai530ka6r2xjabrkir";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    pkgconfig
    go-gir-generator
    deepin-gettext-tools
  ];

  buildInputs = [
    glib
    gtk3
    poppler
    librsvg
    pulseaudio
    alsaLib
    libcanberra
    gnome3.libgudev
  ];

  postPatch = ''
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

  meta = with stdenv.lib; {
    description = "Go-lang bindings for dde-daemon";
    homepage = https://github.com/linuxdeepin/dde-api;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
