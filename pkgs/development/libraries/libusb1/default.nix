{ stdenv
, fetchurl
, pkgconfig
, enableSystemd ? stdenv.isLinux && !stdenv.hostPlatform.isMusl
, systemd ? null
, libobjc
, IOKit
, withStatic ? false
}:

assert enableSystemd -> systemd != null;

stdenv.mkDerivation (rec {
  pname = "libusb";
  version = "1.0.23";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "13dd2a9x290d1q8nb1lqiaf36grcvns5ripk5k2xm0lajmpc04fv";
  };

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs =
    stdenv.lib.optional enableSystemd systemd ++
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  configureFlags =
    # We use `isLinux` here only to avoid mass rebuilds for Darwin, where
    # disabling udev happens automatically. Remove `isLinux` at next big change!
    stdenv.lib.optional (stdenv.isLinux && !enableSystemd) "--disable-udev";

  preFixup = stdenv.lib.optionalString enableSystemd ''
    sed 's,-ludev,-L${systemd.lib}/lib -ludev,' -i $out/lib/libusb-1.0.la
  '';

  meta = with stdenv.lib; {
    homepage = "https://libusb.info/";
    repositories.git = "https://github.com/libusb/libusb";
    description = "cross-platform user-mode USB device library";
    longDescription = ''
      libusb is a cross-platform user-mode library that provides access to USB devices.
    '';
    platforms = platforms.all;
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
} // stdenv.lib.optionalAttrs withStatic {
  # Carefully added here to avoid a mass rebuild.
  # Inline this the next time this package changes.
  dontDisableStatic = withStatic;
})
