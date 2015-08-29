{ stdenv, fetchzip, cmake, libusb, pkgconfig, freeglut, mesa, libXi, libXmu }:

stdenv.mkDerivation rec {
    name = "freenect-${version}";
    version = "0.5.2";
    src = fetchzip {
        url = "https://github.com/OpenKinect/libfreenect/archive/v${version}.tar.gz";
        sha256 = "04p4q19fkh97bn7kf0xsk6mrig2aj10i3s9z6hdrr70l6dfpf4w9";
    };

    buildInputs = [ libusb freeglut mesa libXi libXmu ];
    nativeBuildInputs = [ cmake pkgconfig ];

    meta = {
        description = "Drivers and libraries for the Xbox Kinect device on Windows, Linux, and OS X";
        inherit version;
        homepage = http://openkinect.org;
        license = with stdenv.lib.licenses; [ gpl2 asl20 ];
        maintainers = with stdenv.lib.maintainers; [ bennofs ];
        platforms = stdenv.lib.platforms.linux;
    };
}
