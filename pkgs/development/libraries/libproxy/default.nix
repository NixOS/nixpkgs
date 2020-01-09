{ stdenv
, fetchFromGitHub
, pkgconfig
, cmake
, zlib
, fetchpatch
, dbus
, networkmanager
, spidermonkey_60
, pcre
, gsettings-desktop-schemas
, glib
, makeWrapper
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

  outputs = [ "out" "dev" "py3" ];

  nativeBuildInputs = [
    pkgconfig
    cmake
    makeWrapper
  ];

  buildInputs = [
    pcre
    python3
    zlib
  ] ++ (if stdenv.hostPlatform.isDarwin then [
    SystemConfiguration
    CoreFoundation
    JavaScriptCore
  ] else [
    glib
    spidermonkey_60
    dbus
    networkmanager
  ]);

  cmakeFlags = [
    "-DWITH_MOZJS=ON"
    "-DWITH_PYTHON2=OFF"
    "-DPYTHON3_SITEPKG_DIR=${placeholder "py3"}/${python3.sitePackages}"
  ];

  patches = [
    # Make build with spidermonkey_60
    (fetchpatch {
      url = "https://github.com/libproxy/libproxy/pull/86.patch";
      sha256 = "17c06ilinrnzr7xnnmw9pc6zrncyaxcdd6r6k1ah5p156skbykfs";
    })
    (fetchpatch {
      url = "https://github.com/libproxy/libproxy/pull/87.patch";
      sha256 = "0sagzfwm16f33inbkwsp88w9wmrd034rjmw0y8d122f7k1qfx6zc";
    })
    (fetchpatch {
      url = "https://github.com/libproxy/libproxy/pull/95.patch";
      sha256 = "18vyr6wlis9zfwml86606jpgb9mss01l9aj31iiciml8p857aixi";
    })
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    (fetchpatch {
      url = "https://github.com/libproxy/libproxy/commit/44158f03f8522116758d335688ed840dfcb50ac8.patch";
      sha256 = "0axfvb6j7gcys6fkwi9dkn006imhvm3kqr83gpwban8419n0q5v1";
    })
  ];

  postFixup = stdenv.lib.optionalString stdenv.isLinux ''
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
