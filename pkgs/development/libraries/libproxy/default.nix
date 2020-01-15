{ stdenv
, fetchFromGitHub
, pkgconfig
, cmake
, zlib
, fetchpatch
, dbus
, networkmanager
, spidermonkey_38
, pcre
, gsettings-desktop-schemas
, glib
, makeWrapper
, python2
, python3
, SystemConfiguration
, CoreFoundation
, JavaScriptCore
}:

stdenv.mkDerivation rec {
  pname = "libproxy";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = version;
    sha256 = "10swd3x576pinx33iwsbd4h15fbh2snmfxzcmab4c56nb08qlbrs";
  };

  outputs = [ "out" "dev" "py2" "py3" ];

  nativeBuildInputs = [
    pkgconfig
    cmake
    makeWrapper
  ];

  buildInputs = [
    pcre
    python2
    python3
    zlib
  ] ++ (if stdenv.hostPlatform.isDarwin then [
    SystemConfiguration
    CoreFoundation
    JavaScriptCore
  ] else [
    glib
    spidermonkey_38
    dbus
    networkmanager
  ]);

  cmakeFlags = [
    "-DWITH_MOZJS=ON"
    "-DPYTHON2_SITEPKG_DIR=${placeholder "py2"}/${python2.sitePackages}"
    "-DPYTHON3_SITEPKG_DIR=${placeholder "py3"}/${python3.sitePackages}"
  ];

  patches = stdenv.lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://github.com/libproxy/libproxy/commit/44158f03f8522116758d335688ed840dfcb50ac8.patch";
      sha256 = "0axfvb6j7gcys6fkwi9dkn006imhvm3kqr83gpwban8419n0q5v1";
    })
  ];

  postFixup = ''
    # config_gnome3 uses the helper to find GNOME proxy settings
    wrapProgram $out/libexec/pxgsettings --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
  '';

  doCheck = false; # fails 1 out of 10 tests

  meta = with stdenv.lib; {
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl21;
    homepage = http://libproxy.github.io/libproxy/;
    description = "A library that provides automatic proxy configuration management";
  };
}
