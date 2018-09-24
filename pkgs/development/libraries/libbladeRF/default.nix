{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, git, doxygen, help2man, ncurses, tecla
, libusb1, udev }:

stdenv.mkDerivation rec {
  version = "2.0.2";
  name = "libbladeRF-${version}";

  src = fetchFromGitHub {
    owner = "Nuand";
    repo = "bladeRF";
    rev = "libbladeRF_v${version}";
    sha256 = "18qwljjdnf4lds04kc1zvslr5hh9cjnnjkcy07lbkrq7pj0pfnc6";
  };

  nativeBuildInputs = [ pkgconfig ];
  # ncurses used due to https://github.com/Nuand/bladeRF/blob/ab4fc672c8bab4f8be34e8917d3f241b1d52d0b8/host/utilities/bladeRF-cli/CMakeLists.txt#L208
  buildInputs = [ cmake git doxygen help2man tecla libusb1 ]
    ++ lib.optionals stdenv.isLinux [ udev ]
    ++ lib.optionals stdenv.isDarwin [ ncurses ];

  # Fixup shebang
  prePatch = "patchShebangs host/utilities/bladeRF-cli/src/cmd/doc/generate.bash";

  # Let us avoid nettools as a dependency.
  patchPhase = ''
    sed -i 's/$(hostname)/hostname/' host/utilities/bladeRF-cli/src/cmd/doc/generate.bash
  '';

  cmakeFlags = [
    "-DBUILD_DOCUMENTATION=ON"
  ] ++ lib.optionals stdenv.isLinux [
    "-DUDEV_RULES_PATH=etc/udev/rules.d"
    "-DINSTALL_UDEV_RULES=ON"
  ];

  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    homepage = https://nuand.com/libbladeRF-doc;
    description = "Supporting library of the BladeRF SDR opensource hardware";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ funfunctor ];
    platforms = platforms.unix;
  };
}
