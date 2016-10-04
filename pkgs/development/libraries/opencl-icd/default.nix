{ stdenv, fetchurl, ruby, opencl-headers }: let

  version = "2.2.9";

in stdenv.mkDerivation {

  name = "opencl-icd-${version}";
  buildInputs = [ ruby opencl-headers ];
  configureFlags = [ "--enable-official-khronos-headers" ];
  src = fetchurl {
    url = "https://forge.imag.fr/frs/download.php/716/ocl-icd-${version}.tar.gz";
    sha256 = "1rgaixwnxmrq2aq4kcdvs0yx7i6krakarya9vqs7qwsv5hzc32hc";
  };

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
