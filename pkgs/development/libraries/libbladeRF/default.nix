{ stdenv, lib, fetchFromGitHub, fetchpatch, pkg-config, cmake, git, doxygen, help2man, ncurses, tecla
, libusb1, udev }:
let
  # fetch submodule
  noos = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "no-OS";
    rev = "0bba46e6f6f75785a65d425ece37d0a04daf6157";
    sha256 = "0is79dhsyp9xmlnfdr1i5s1c22ipjafk9d35jpn5dynpvj86m99c";
  };
in stdenv.mkDerivation rec {
  pname = "libbladeRF";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "Nuand";
    repo = "bladeRF";
    rev = "libbladeRF_v${version}";
    sha256 = "05axh51lrzxpz2qfswnjwxpfk3mlsv2wc88dd12gfr1karn5jwz9";
  };

  nativeBuildInputs = [ cmake pkg-config git doxygen help2man ];
  # ncurses used due to https://github.com/Nuand/bladeRF/blob/ab4fc672c8bab4f8be34e8917d3f241b1d52d0b8/host/utilities/bladeRF-cli/CMakeLists.txt#L208
  buildInputs = [ tecla libusb1 ]
    ++ lib.optionals stdenv.isLinux [ udev ]
    ++ lib.optionals stdenv.isDarwin [ ncurses ];


  postUnpack = ''
    cp -r ${noos}/* source/thirdparty/analogdevicesinc/no-OS/
  '';

  # Fixup shebang
  prePatch = "patchShebangs host/utilities/bladeRF-cli/src/cmd/doc/generate.bash";

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
    homepage = "https://nuand.com/libbladeRF-doc";
    description = "Supporting library of the BladeRF SDR opensource hardware";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
