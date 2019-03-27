{ stdenvNoCC, fetchzip }:

let
  mspgccVersion = "6_1_0_0";
  version = "1.206";
in stdenvNoCC.mkDerivation {
  name = "msp430-gcc-support-files-${version}";
  src = fetchzip {
    url = "http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/${mspgccVersion}/exports/msp430-gcc-support-files-${version}.zip";
    sha256 = "0h297jms3gkmdcqmfpr3cg6v9wxnms34qbwvwl2fkmrz20vk766q";
  };

  buildCommand = ''
    find $src/include -name '*.ld' | xargs install -Dm0644 -t $out/lib
    find $src/include -name '*.h' | xargs install -Dm0644 -t $out/include
    install -Dm0644 -t $out/include $src/include/devices.csv

    # appease bintoolsWrapper_addLDVars, search path needed for ld scripts
    touch $out/lib/lib
  '';

  meta = with stdenvNoCC.lib; {
    description = ''
      Development headers and linker scripts for TI MSP430 microcontrollers
    '';
    homepage = https://www.ti.com/tool/msp430-gcc-opensource;
    license = licenses.bsd3;
    platforms = [ "msp430-none" ];
    maintainers = with maintainers; [ aerialx ];
  };
}
