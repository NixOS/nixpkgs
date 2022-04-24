{ stdenv
, lib
, fetchurl, unzip
, boost, pugixml
, hidapi
, libusb1 ? null
}:

with lib;
assert stdenv.isLinux -> libusb1 != null;

let
  hidapiDriver = optionalString stdenv.isLinux "-libusb";

in stdenv.mkDerivation {
  pname = "msp-debug-stack";
  version = "3.15.1.1";

  src = fetchurl {
    url = "http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPDS/3_15_1_001/export/MSPDebugStack_OS_Package_3_15_1_1.zip";
    sha256 = "1j5sljqwc20zrb50mrji4mnmw5i680qc7n0lb0pakrrxqjc9m9g3";
  };
  sourceRoot = ".";

  enableParallelBuilding = true;
  libName = "libmsp430${stdenv.hostPlatform.extensions.sharedLibrary}";
  makeFlags = [ "OUTPUT=$(libName)" "HIDOBJ=" ];
  NIX_LDFLAGS = [ "-lpugixml" "-lhidapi${hidapiDriver}" ];
  NIX_CFLAGS_COMPILE = [ "-I${hidapi}/include/hidapi" ];

  patches = [ ./bsl430.patch ];

  preBuild = ''
    rm ThirdParty/src/pugixml.cpp
    rm ThirdParty/include/pugi{config,xml}.hpp
  '' + optionalString stdenv.isDarwin ''
    makeFlagsArray+=(OUTNAME="-install_name ")
  '';

  installPhase = ''
    install -Dm0755 -t $out/lib $libName
    install -Dm0644 -t $out/include DLL430_v3/include/*.h
  '';

  nativeBuildInputs = [ unzip ];
  buildInputs = [ boost hidapi pugixml ]
    ++ optional stdenv.isLinux libusb1;

  meta = {
    description = "TI MSP430 FET debug driver";
    homepage = "https://www.ti.com/tool/MSPDS";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ aerialx ];
  };
}
