{ stdenv, lib, fetchFromGitHub, fetchpatch, pkgconfig, cmake, git, doxygen, help2man, ncurses, tecla
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

  # Fixes macos and freebsd compilation issue.
  # https://github.com/Nuand/bladeRF/commit/0cb4ea888543b2dc75b876f7024e180854fbe9c3
  patches = [ (fetchpatch {
                name = "fix-OSX-and-FreeBSD-build.patch";
                url = "https://github.com/Nuand/bladeRF/commit/0cb4ea88.diff";
                sha256 = "1ccpa69vz2nlpdnxprh4rd1pgphk82z5lfmbrfdkn7srw6nxl469";
              })
            ];

  # Let us avoid nettools as a dependency.
  postPatch = ''
    sed -i 's/$(hostname)/hostname/' host/utilities/bladeRF-cli/src/cmd/doc/generate.bash
  '';

  cmakeFlags = [
    "-DBUILD_DOCUMENTATION=ON"
  ] ++ lib.optionals stdenv.isLinux [
    "-DUDEV_RULES_PATH=etc/udev/rules.d"
    "-DINSTALL_UDEV_RULES=ON"
    "-DBLADERF_GROUP=bladerf"
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
