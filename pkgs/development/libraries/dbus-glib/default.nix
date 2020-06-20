{ stdenv, fetchurl, buildPackages
, pkgconfig, expat, gettext, libiconv, dbus, glib
}:

stdenv.mkDerivation rec {
  name = "dbus-glib-0.110";

  src = fetchurl {
    url = "${meta.homepage}/releases/dbus-glib/${name}.tar.gz";
    sha256 = "09g8swvc95bk1z6j8sw463p2v0dqmgm2zjfndf7i8sbcyq67dr3w";
  };

  outputs = [ "out" "dev" "devdoc" ];
  outputBin = "dev";

  nativeBuildInputs = [ pkgconfig gettext glib ];

  buildInputs = [ expat libiconv ];

  propagatedBuildInputs = [ dbus glib ];

  configureFlags = [ "--exec-prefix=${placeholder "dev"}" ] ++
    stdenv.lib.optional (stdenv.buildPlatform != stdenv.hostPlatform)
      "--with-dbus-binding-tool=${buildPackages.dbus-glib.dev}/bin/dbus-binding-tool";

  doCheck = false;

  passthru = { inherit dbus glib; };

  meta = {
    homepage = "https://dbus.freedesktop.org";
    license = with stdenv.lib.licenses; [ afl21 gpl2 ];
    description = "Obsolete glib bindings for D-Bus lightweight IPC mechanism";
    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
