{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, enableSystemd ? stdenv.isLinux && !stdenv.hostPlatform.isMusl
, systemd ? null
, libobjc
, IOKit
, withStatic ? false
}:

assert enableSystemd -> systemd != null;

stdenv.mkDerivation rec {
  pname = "libusb";
  version = "1.0.23";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "libusb";
    rev = "v${version}";
    sha256 = "0mxbpg01kgbk5nh6524b0m4xk7ywkyzmc3yhi5asqcsd3rbhjj98";
  };

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  propagatedBuildInputs =
    stdenv.lib.optional enableSystemd systemd ++
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  dontDisableStatic = withStatic;

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    sed 's,-ludev,-L${stdenv.lib.getLib systemd}/lib -ludev,' -i $out/lib/libusb-1.0.la
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
}
