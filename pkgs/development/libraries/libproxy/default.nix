{ lib, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, zlib
, dbus
, networkmanager
, enableJavaScript ? stdenv.isDarwin || lib.meta.availableOn stdenv.hostPlatform spidermonkey_78
, spidermonkey_78
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
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = version;
    sha256 = "0v8q4ln0pd5231kidpi8wpwh0chcjwcmawcki53czlpdrc09z96r";
  };

  outputs = [ "out" "dev" "py3" ];

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    pcre
    python3
    zlib
  ] ++ lib.optionals enableJavaScript [
    (if stdenv.hostPlatform.isDarwin then JavaScriptCore else spidermonkey_78)
  ] ++ (if stdenv.hostPlatform.isDarwin then [
    SystemConfiguration
    CoreFoundation
  ] else [
    glib
    dbus
    networkmanager
  ]);

  cmakeFlags = [
    "-DWITH_PYTHON2=OFF"
    "-DPYTHON3_SITEPKG_DIR=${placeholder "py3"}/${python3.sitePackages}"
  ] ++ lib.optional (enableJavaScript && !stdenv.hostPlatform.isDarwin) "-DWITH_MOZJS=ON";

  postFixup = lib.optionalString stdenv.isLinux ''
    # config_gnome3 uses the helper to find GNOME proxy settings
    wrapProgram $out/libexec/pxgsettings --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
  '';

  doCheck = false; # fails 1 out of 10 tests

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.lgpl21;
    homepage = "http://libproxy.github.io/libproxy/";
    description = "A library that provides automatic proxy configuration management";
  };
}
