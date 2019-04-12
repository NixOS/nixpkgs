{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig,
  alsaLib,
  bc,
  blur-effect,
  coreutils,
  dbus-factory,
  deepin,
  deepin-gettext-tools,
  fontconfig,
  glib,
  go,
  go-dbus-factory,
  go-gir-generator,
  go-lib,
  grub2,
  gtk3,
  libcanberra,
  libgudev,
  librsvg,
  poppler,
  pulseaudio,
  rfkill,
  xcur2png
}:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "dde-api";
  version = "3.18.1";

  goPackagePath = "pkg.deepin.io/dde/api";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0y8v18f6l3ycysdn4qi7c93z805q7alji8wix4j4qh9x9r35d728";
  };

  goDeps = ./deps.nix;

  outputs = [ "out" ];

  nativeBuildInputs = [
    pkgconfig
    deepin-gettext-tools # build
    dbus-factory         # build
    go-dbus-factory      # needed
    go-gir-generator     # needed
    go-lib               # build
    deepin.setupHook
  ];

  buildInputs = [
    alsaLib     # needed
    bc          # run (to adjust grub theme?)
    blur-effect # run (is it really needed?)
    coreutils   # run (is it really needed?)
    fontconfig  # run (is it really needed?)
    #glib        # ? arch
    grub2       # run (is it really needed?)
    gtk3        # build run
    libcanberra # build run
    libgudev    # needed
    librsvg     # build run
    poppler     # build run
    pulseaudio  # needed
    rfkill      # run
    xcur2png    # run
    #locales     # run (locale-helper needs locale-gen, which is unavailable on NixOS?)
 ];

  postPatch = ''
    searchHardCodedPaths # debugging

    sed -i -e "s|/var|$out/var|" Makefile

    # TODO: confirm where to install grub themes
    sed -i -e "s|/boot/grub|$out/boot/grub|" Makefile

    fixPath $out /usr/lib/deepin-api \
      lunar-calendar/main.go \
      misc/services/com.deepin.api.CursorHelper.service \
      misc/services/com.deepin.api.Graphic.service \
      misc/services/com.deepin.api.LunarCalendar.service \
      misc/services/com.deepin.api.Pinyin.service \
      misc/system-services/com.deepin.api.Device.service \
      misc/system-services/com.deepin.api.LocaleHelper.service \
      misc/system-services/com.deepin.api.SoundThemePlayer.service \
      misc/systemd/system/deepin-shutdown-sound.service \
      theme_thumb/gtk/gtk.go \
      thumbnails/gtk/gtk.go
  '';

  buildPhase = ''
    export GOCACHE="$TMPDIR/go-cache";
    make -C go/src/${goPackagePath}
  '';

  installPhase = ''
    make install PREFIX="$out" SYSTEMD_LIB_DIR="$out/lib" -C go/src/${goPackagePath}
    mv $out/share/gocode $out/share/go
    remove-references-to -t ${go} $out/bin/* $out/lib/deepin-api/*
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
