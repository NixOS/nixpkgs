{ lib, stdenvNoCC, fetchzip }:

let
  mspgccVersion = "6_1_1_0";
in stdenvNoCC.mkDerivation rec {
  pname = "msp430-gcc-support-files";
  version = "1.207";
  src = fetchzip {
    url = "http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/${mspgccVersion}/exports/msp430-gcc-support-files-${version}.zip";
    sha256 = "1gyi9zc5vh9c1lxd22dwvk6b17dcd17hah2rayr062p4l51kzam1";
  };

  buildCommand = ''
    find $src/include -name '*.ld' | xargs install -Dm0644 -t $out/lib
    find $src/include -name '*.h' | xargs install -Dm0644 -t $out/include
    install -Dm0644 -t $out/include $src/include/devices.csv

    # appease bintoolsWrapper_addLDVars, search path needed for ld scripts
    touch $out/lib/lib
  '';

  meta = with lib; {
    description = ''
      Development headers and linker scripts for TI MSP430 microcontrollers
    '';
    homepage = "https://www.ti.com/tool/msp430-gcc-opensource";
    license = licenses.bsd3;
    platforms = [ "msp430-none" ];
    maintainers = with maintainers; [ aerialx ];
  };
}
