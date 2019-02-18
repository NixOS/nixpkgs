{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch, pkgconfig,
  dbus-factory, go-dbus-factory, go-gir-generator, go-lib,
  deepin-gettext-tools, dde-api, alsaLib, glib, gtk3, libinput, libnl,
  librsvg, linux-pam, networkmanager, pulseaudio, xorg, gnome3,
  python3Packages, hicolor-icon-theme, go, deepin }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "dde-daemon";
  version = "3.6.0";

  goPackagePath = "pkg.deepin.io/dde/daemon";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0gn2zp34wg79lvzdfla6yb4gs3f9ll83kj765zvig1wpx51nq1aj";
  };

  patches = [
    # https://github.com/linuxdeepin/dde-daemon/issues/51
    (fetchpatch {
      name = "dde-daemon_3.2.3.patch";
      url = https://github.com/jouyouyun/tap-gesture-patches/raw/master/patches/dde-daemon_3.2.3.patch;
      sha256 = "0a3xb15czpfl2vajpf7ycw37vr7fbw2png1a67mvjjkgx7d1k7dg";
    })
  ];

  goDeps = ./deps.nix;

  outputs = [ "out" ];

  nativeBuildInputs = [
    pkgconfig
    dbus-factory
    go-dbus-factory
    go-gir-generator
    go-lib
    deepin-gettext-tools
    dde-api
    linux-pam
    networkmanager
    networkmanager.dev
    python3Packages.python
  ];

  buildInputs = [
    alsaLib
    glib
    gnome3.libgudev
    gtk3
    hicolor-icon-theme
    libinput
    libnl
    librsvg
    pulseaudio
  ];

  postPatch = ''
    patchShebangs .

    sed -i network/nm_generator/Makefile -e 's,/usr/share/gir-1.0/NM-1.0.gir,${networkmanager.dev}/share/gir-1.0/NM-1.0.gir,'

    sed -i -e "s|{DESTDIR}/etc|{DESTDIR}$out/etc|" Makefile
    sed -i -e "s|{DESTDIR}/var|{DESTDIR}$out/var|" Makefile
    sed -i -e "s|{DESTDIR}/lib|{DESTDIR}$out/lib|" Makefile

    find -type f -exec sed -i -e "s,/usr/lib/deepin-daemon,$out/lib/deepin-daemon," {} +
  '';

  buildPhase = ''
    make -C go/src/${goPackagePath}
    # compilation of the nm module is failing
    #make -C go/src/${goPackagePath}/network/nm_generator gen-nm-code
  '';

  installPhase = ''
    make install PREFIX="$out" -C go/src/${goPackagePath}
    remove-references-to -t ${go} $out/lib/deepin-daemon/*
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Daemon for handling Deepin Desktop Environment session settings";
    homepage = https://github.com/linuxdeepin/dde-daemon;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
