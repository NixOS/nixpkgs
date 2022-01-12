{ stdenv, lib, fetchurl, unzip, autoPatchelfHook }:

with lib;

let
  archPostfix = optionalString (stdenv.is64bit && !stdenv.isDarwin) "_64";
in stdenv.mkDerivation rec {
  pname = "msp-debug-stack-bin";
  version = "3.15.1.1";
  src = fetchurl {
    url = "http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPDS/3_15_1_001/export/MSP430_DLL_Developer_Package_Rev_3_15_1_1.zip";
    sha256 = "1m1ssrwbhqvqwbp3m4hnjyxnz3f9d4acz9vl1av3fbnhvxr0d2hb";
  };
  sourceRoot = ".";

  libname =
    if stdenv.hostPlatform.isWindows then "MSP430${archPostfix}.dll"
    else "libmsp430${archPostfix}${stdenv.hostPlatform.extensions.sharedLibrary}";

  nativeBuildInputs = [ unzip autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc ];

  installPhase = ''
    install -Dm0755 $libname $out/lib/''${libname//_64/}
    install -Dm0644 -t $out/include Inc/*.h
  '';

  meta = {
    description = "Unfree binary release of the TI MSP430 FET debug driver";
    homepage = "https://www.ti.com/tool/MSPDS";
    license = licenses.unfree;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ aerialx ];
  };
}
