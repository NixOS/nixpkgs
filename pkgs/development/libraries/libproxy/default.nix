{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
, zlib
, dbus
, networkmanager
, enableJavaScript ? stdenv.isDarwin || lib.meta.availableOn stdenv.hostPlatform duktape
, duktape
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
  version = "0.4.18";

  src = fetchFromGitHub {
    owner = "libproxy";
    repo = "libproxy";
    rev = version;
    hash = "sha256-pqj1LwRdOK2CUu3hYIsogQIXxWzShDuKEbDTbtWkgnQ=";
  };

  patches = lib.optionals stdenv.isDarwin [
    # https://github.com/libproxy/libproxy/pull/189
    (fetchpatch {
      url = "https://github.com/libproxy/libproxy/commit/4331b9db427ce2c25ff5eeb597bec4bc35ed1a0b.patch";
      sha256 = "sha256-uTh3rYVvEke1iWVHsT3Zj2H1F+gyLrffcmyt0JEKaCA=";
    })
  ];

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
    (if stdenv.hostPlatform.isDarwin then JavaScriptCore else duktape)
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
    homepage = "https://libproxy.github.io/libproxy/";
    description = "A library that provides automatic proxy configuration management";
  };
}
