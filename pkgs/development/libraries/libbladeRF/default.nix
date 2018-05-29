{ stdenv, fetchFromGitHub, pkgconfig, cmake, git, doxygen, help2man, tecla
, libusb1, udev }:

stdenv.mkDerivation rec {
  version = "1.9.0";
  name = "libbladeRF-${version}";

  src = fetchFromGitHub {
    owner = "Nuand";
    repo = "bladeRF";
    rev = "libbladeRF_v${version}";
    sha256 = "0frvphp4xxdxwzmi94b0asl7b891sd3fk8iw9kfk8h6f3cdhj8xa";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake git doxygen help2man tecla libusb1 udev ];

  # Fixup shebang
  prePatch = "patchShebangs host/utilities/bladeRF-cli/src/cmd/doc/generate.bash";

  # Let us avoid nettools as a dependency.
  patchPhase = ''
    sed -i 's/$(hostname)/hostname/' host/utilities/bladeRF-cli/src/cmd/doc/generate.bash
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DUDEV_RULES_PATH=etc/udev/rules.d"
    "-DINSTALL_UDEV_RULES=ON"
    "-DBUILD_DOCUMENTATION=ON"
  ];

  meta = with stdenv.lib; {
    homepage = https://www.nuand.com/;
    description = "Supporting library of the BladeRF SDR opensource hardware";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ funfunctor ];
    platforms = with platforms; linux;
  };
}
