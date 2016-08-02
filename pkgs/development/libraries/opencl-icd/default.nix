{ stdenv, fetchurl, ruby, opencl-headers }:

stdenv.mkDerivation rec {
  name = "opencl-icd-${version}";
  version = "2.2.9";

  src = fetchurl {
    url = "https://forge.imag.fr/frs/download.php/716/ocl-icd-${version}.tar.gz";
    sha256 = "1rgaixwnxmrq2aq4kcdvs0yx7i6krakarya9vqs7qwsv5hzc32hc";
  };

  buildInputs = [ ruby opencl-headers ];

  configureFlags = [ "--enable-official-khronos-headers" ];

  meta = with stdenv.lib; {
    description = "This free ICD Loader can load any (free or non free) ICD";
    homepage = https://forge.imag.fr/projects/ocl-icd/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zimbatm ];
  };
}
