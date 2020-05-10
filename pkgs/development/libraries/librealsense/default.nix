{ stdenv, fetchFromGitHub, cmake, libusb1, ninja, pkgconfig, pkgs,

  # The examples for instance contain realsense-viewer.
  buildExamples ? false, xorg, glfw3, libGLU
}:

# See ./nixos/modules/hardware/intel-realsense.nix's option to also get udev rules
# TODO: turn buildExamples into multi output derivation

let exampleDeps = {
  inherit (xorg) libX11 libXrender libXtst libXdamage libXi libXext libXfixes libXcomposite;
  inherit glfw3;
  inherit libGLU;
};

in

stdenv.mkDerivation rec {
  pname = "librealsense";
  version = "2.33.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "IntelRealSense";
    repo = pname;
    rev = "v${version}";
    sha256 = "04macplj3k2sdpf1wdjm6gsghak5dzfhi2pmr47qldh2sy2zz0a3";
  };

  enableParalellBuilding = true;

  buildInputs = [
    libusb1
  ] ++ pkgs.lib.optionals buildExamples (builtins.attrValues exampleDeps);

  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
  ];

  cmakeFlags = [ ''-DBUILD_EXAMPLES=${if buildExamples then "true" else "false"}'' ];

  # copy udev rules to $out
  # fix executable paths in udev rules and copy them to $udev_bins_path
  postInstall = ''
  cd ..
  mkdir -p $out/lib/udev/rules.d
  udev_bins_path=$out/udev-bins
  mkdir -p $udev_bins_path
  cp -ra config/{usb-R200-in,usb-R200-in_udev} $udev_bins_path
  sed -i 's@/bin/bash@/bin/sh@' $udev_bins_path/*
  chmod +x $udev_bins_path/*
  cp config/99-realsense-libusb.rules $out/lib/udev/rules.d/99-realsense-libusb.rules
  sed -i -e "s@/usr/local/bin/\\(usb-R200-in_udev\\|usb-R200-in\\)@$udev_bins_path/\\1@" -e "s@/bin/sh@$(type -p sh)@" $udev_bins_path/* $out/lib/udev/rules.d/99-realsense-libusb.rules
  '';

  meta = with stdenv.lib; {
    description = "A cross-platform library for Intel® RealSense™ depth cameras (D400 series and the SR300)";
    homepage = "https://github.com/IntelRealSense/librealsense";
    license = licenses.asl20;
    maintainers = with maintainers; [ brian-dawn ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
