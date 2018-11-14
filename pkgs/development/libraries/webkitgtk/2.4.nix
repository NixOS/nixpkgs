{ stdenv, fetchurl, fetchpatch, perl, python, ruby, bison, gperf, flex
, pkgconfig, which, gettext, gobjectIntrospection, pruneLibtoolFiles
, gtk2, gtk3, wayland, libwebp, enchant, sqlite
, libxml2, libsoup, libsecret, libxslt, harfbuzz, xorg
, gst-plugins-base, libobjc
, withGtk2 ? false
, enableIntrospection ? !stdenv.isDarwin
, enableCredentialStorage ? !stdenv.isDarwin
, readline, libedit
}:

assert stdenv.isDarwin -> !enableIntrospection;
assert stdenv.isDarwin -> !enableCredentialStorage;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "webkitgtk-${version}";
  version = "2.4.11";

  meta = with stdenv.lib; {
    description = "Web content rendering engine, GTK+ port";
    homepage = http://webkitgtk.org/;
    license = licenses.bsd2;
    platforms = with platforms; linux ++ darwin;
    maintainers = [];
    knownVulnerabilities = [
      "WSA-2016-0004"
      "WSA-2016-0005"
      "WSA-2016-0006"
      "WSA-2017-0001"
      "WSA-2017-0002"
    ];
  };

  src = fetchurl {
    url = "https://webkitgtk.org/releases/${name}.tar.xz";
    sha256 = "1xsvnvyvlywwyf6m9ainpsg87jkxjmd37q6zgz9cxb7v3c2ym2jq";
  };

  CC = "cc";

  prePatch = ''
    patchShebangs Tools/gtk
  '';
  patches = [
    ./webcore-svg-libxml-cflags.patch
    (fetchpatch {
      url = https://raw.githubusercontent.com/gentoo/gentoo/7c5457e265bd40c156a8fe6b2ff94a4e34bcea8e/net-libs/webkit-gtk/files/webkit-gtk-2.4.9-gcc-6.patch;
      sha256 = "0ll93dr5vxd40wvly1jaw41lvw86krac0jc6k6cacrps4i5ql5j0";
    })
  ] ++ optionals stdenv.isDarwin [
    ./configure.patch
    ./quartz-webcore.patch
    ./libc++.patch
    ./plugin-none.patch
  ] ++ optionals stdenv.hostPlatform.isMusl [
    ./fix-execinfo.patch
  ];

  configureFlags = with stdenv.lib; [
    "--disable-geolocation"
    "--disable-jit"
    # needed for parallel building
    "--enable-dependency-tracking"
    (optionalString enableIntrospection "--enable-introspection")
  ] ++ optional withGtk2 [
    "--with-gtk=2.0"
  ] ++ optionals (withGtk2 || stdenv.isDarwin) [
    "--disable-webkit2"
  ] ++ optionals stdenv.isDarwin [
    "--disable-x11-target"
    "--enable-quartz-target"
    "--disable-web-audio"
    "CFLAGS=-DJSC_OBJC_API_ENABLED=0"
    "CXXFLAGS=-DJSC_OBJC_API_ENABLED=0"
  ] ++ optionals (!enableCredentialStorage) [
    "--disable-credential-storage"
  ];

  NIX_CFLAGS_COMPILE = [
    "-DU_NOEXCEPT="
    "-Wno-expansion-to-defined"
  ];

  dontAddDisableDepTrack = true;

  nativeBuildInputs = [
    perl python ruby bison gperf flex
    pkgconfig which gettext gobjectIntrospection pruneLibtoolFiles
  ];

  buildInputs = [
    gtk2 libwebp enchant
    libxml2 libxslt
    gst-plugins-base sqlite xorg.libXt xorg.libXdamage
  ] ++ optionals enableCredentialStorage [
    libsecret
  ] ++ (if stdenv.isDarwin then [
    readline libedit libobjc
  ] else [
    wayland
  ]);

  propagatedBuildInputs = [
    libsoup harfbuzz/*icu in *.la*/
    (if withGtk2 then gtk2 else gtk3)
  ];

  enableParallelBuilding = true;

}
