{ stdenv
, fetchurl
, cmake
, systemd
, libudev
, acpid }:
let
  version = "2.6";
in
stdenv.mkDerivation {
  name = "libthinkpad-${ version }";

  src = fetchurl {
    url = "https://github.com/libthinkpad/libthinkpad/archive/${ version }.tar.gz";
    sha256 = "1yxaj063h68s3phka05fphpsnwp0iwgjnwdn8mg4a8chqc2zb5cq";
  };

  buildInputs = [ cmake systemd.dev libudev.dev acpid ];

  meta = with stdenv.lib; {
    description = "Library to change configuration and manage hardware events for ThinkPads";
    homepage = https://github.com/libthinkpad/libthinkpad;
    longDescription = ''
      libthinkpad is a userspace general purpose library to change
      hardware configuration and manage hardware events in the userspace
      for Lenovo/IBM ThinkPad laptops.

      The library unifies ACPI dispatchers, hardware information systems
      and hardware configuration interfaces into a single userspace library.
    '';
    license = [ licenses.bsd2 ];
    maintainers = with maintainers; [ cyraxjoe ];
    platforms = platforms.linux;
  };
}
