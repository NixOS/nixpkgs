{ pkgs, lib }:

# Overrides for nidaqmx packages
# Often propagatedBuildInputs are added. It's not unlikely that
# shared objects declared unneeded dependencies that could be removed instead.

self: super: with super; with self;

{
  libnipxigp15 = super.libnipxigp15.override {
    propagatedBuildInputs = [ 
      super.libnipxirm1 
    ];
  };

  ni-pxiplatformservices-libs = super.ni-pxiplatformservices-libs.override {
    propagatedBuildInputs = [ 
      super.niswactions 
      super.libnipxisvc2 
    ];
  };

  ni-avahi-client = super.ni-avahi-client.override {
    propagatedBuildInputs = [ 
      pkgs.avahi
    ];
  };

  libnimru2u2 = super.libnimru2u2.override {
    propagatedBuildInputs = [
      super.ni-mxdf
      super.libnidimu1
    ];
  };

  ni-syscfg-runtime = super.ni-syscfg-runtime.override {
      # So we don't have to bother with libssleay32.so.1 and libeay32.so.1
    preBuild = ''
      rm usr/lib/x86_64-linux-gnu/libmxRmCfg.so.19.0.0
    '';
  };

  ni-controllerdriver = super.ni-controllerdriver.override {
    propagatedBuildInputs = [
      ni-mxs
    ];
  };

  ni-rtsi-libs = super.ni-rtsi-libs.override {
    propagatedBuildInputs = [
      ni-mxs
    ];
  };

  ni-rtsi-pal-libs = super.ni-rtsi-pal-libs.override {
    propagatedBuildInputs = [
      ni-mxdf
      ni-rtsi-libs
      libnidimu1
    ];
  };

  ni-daqmx-libs = super.ni-daqmx-libs.override {
    propagatedBuildInputs = [ 
      ni-rtsi-pal-libs
      libnidimu1
      ni-sysapi
      pkgs.avahi
      ni-avahi-client
      libnimru2u2
    ];
  };

  ni-daqmx-mio-libs = super.ni-daqmx-mio-libs.override {
    propagatedBuildInputs = [
      ni-mdbg
      libnidrumc1-bin
      libusb-ni1
    ];

  };

  nissli = super.nissli.overrideAttrs(oldAttrs: {
    preBuild = ''
      patchelf --remove-needed libeay32.so.1 usr/lib64/natinst/nissl/libssleay32.so.19.0.0
      patchelf --remove-needed libstdc++.so.6 usr/lib64/natinst/nissl/libssleay32.so.19.0.0
    '';
  });

  nicurli = super.nicurli.overrideAttrs(oldAttrs: {
    preBuild = ''
      patchelf --remove-needed libssleay32.so.1 usr/lib64/natinst/nicurl/libcurlimpl.so.19.0.0
      patchelf --remove-needed libeay32.so.1 usr/lib64/natinst/nicurl/libcurlimpl.so.19.0.0
      patchelf --remove-needed libstdc++.so.6 usr/lib64/natinst/nicurl/libcurlimpl.so.19.0.0
    '';
  });

  ni-daqmx-switch-libs = super.ni-daqmx-switch-libs.override {
    propagatedBuildInputs = [ 
      ni-daqmx-libs
      ni-daqmx-mio-libs
    ];
  };

  libnidaqmx = super.libnidaqmx.override {
    propagatedBuildInputs = [ ni-daqmx-libs ];
  };

  ni-dim = null; # Empty package

  ni-pxisa-compliance = null; # Empty package

  ni-pxiplatformservices = null; # Empty package

  ni-kal = super.ni-kal.override {
    isKernelModule = true;
  };

  dkms = null; # We don't use dkms in NixOS. Other distro's have their own dkms.

  

  # openssl-libeay = pkgs.stdenv.mkDerivation {
  #   name = "openssl-libeay";
  #   unpackPhase = ":";
  #   buildPhase = ''
  #     mkdir -p build
  #     cd build
  #     cp ${lib.getLib pkgs.openssl_1_0_2}/lib
  #   '';
  #   installPhase = ''
  #     mkdir -p $out
  #     lib.getLib openssl
  #   '';
  # };

}