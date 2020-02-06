{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, git, doxygen, help2man, ncurses, tecla
, libusb1, udev }:

let
  # fetch submodule
  noos = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "no-OS";
    rev = "0bba46e6f6f75785a65d425ece37d0a04daf6157";
    sha256 = "0is79dhsyp9xmlnfdr1i5s1c22ipjafk9d35jpn5dynpvj86m99c";
  };

  version = "2.2.1";

in stdenv.mkDerivation {
  pname = "libbladeRF";
  inherit version;

  src = fetchFromGitHub {
    owner = "Nuand";
    repo = "bladeRF";
    rev = "libbladeRF_v${version}";
    sha256 = "0g89al4kwfbx1l3zjddgb9ay4mhr7zk0ndchca3sm1vq2j47nf4l";
  };

  nativeBuildInputs = [ pkgconfig ];
  # ncurses used due to https://github.com/Nuand/bladeRF/blob/ab4fc672c8bab4f8be34e8917d3f241b1d52d0b8/host/utilities/bladeRF-cli/CMakeLists.txt#L208
  buildInputs = [ cmake git doxygen help2man tecla libusb1 ]
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
    homepage = https://nuand.com/libbladeRF-doc;
    description = "Supporting library of the BladeRF SDR opensource hardware";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ funfunctor ];
    platforms = platforms.unix;
  };
}
