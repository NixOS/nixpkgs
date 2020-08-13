{ stdenv, fetchFromGitHub, cmake, doxygen, libusb1, pkgconfig, expat }:

stdenv.mkDerivation rec {
  name = "libnifalcon-1.1";

  src = fetchFromGitHub {
    owner = "libnifalcon";
    repo = "libnifalcon";
    rev = "c1546ec8d9a94b3be7d74f8ba9f1a121a0ebb0c2";
    sha256 = "1gp2cf56rlnlw785vl90w6scpknajw2mdny26yqlx5yl277x9b9s";
  };

  buildInputs = [ cmake libusb1 doxygen pkgconfig expat ];
  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    homepage = "http://qdot.github.com/libnifalcon/";
    description = "Open source drivers for the Novint Falcon haptic controller";
    license = licenses.bsd3;

    longDescription =
      ''libnifalcon is a development library for the NovInt Falcon,
        and is an open source, crossplatform alternative to NovInt’s SDK.

        libnifalcon provides basic functionality to connect to the falcon and
        load firmware to the internal microcontroller. In addition, it comes
        with sample functionality made available through the firmware available
        in NovInt’s drivers (the novint.bin file in TestUtilties and the
        nifalcon_test_fw files for the library source). This firmware is
        distributed in the firmware directory of the source distribution, and
        is required for the findfalcons utility to run.
      '';

    maintainers = with maintainers; [ wesliao ];
  };

}
