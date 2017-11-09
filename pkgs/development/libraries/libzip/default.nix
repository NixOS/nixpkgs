{ stdenv, fetchurl, perl, zlib }:

stdenv.mkDerivation rec {
  name = "libzip-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "http://www.nih.at/libzip/${name}.tar.gz";
    sha256 = "1633dvjc08zwwhzqhnv62rjf1abx8y5njmm8y16ik9iwd07ka6d9";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ perl ];
  propagatedBuildInputs = [ zlib ];

  preInstall = ''
    patchShebangs man/handle_links
  '';

  # At least mysqlWorkbench cannot find zipconf.h; I think also openoffice
  # had this same problem.  This links it somewhere that mysqlworkbench looks.
  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/libzip $dev/lib/libzip
    ( cd $dev/include ; ln -s ../lib/libzip/include/zipconf.h zipconf.h )
  '';

  meta = {
    homepage = http://www.nih.at/libzip;
    description = "A C library for reading, creating and modifying zip archives";
    platforms = stdenv.lib.platforms.unix;
  };
}
