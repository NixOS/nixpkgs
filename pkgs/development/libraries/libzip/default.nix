{ stdenv, fetchurl, perl, zlib }:

stdenv.mkDerivation rec {
  name = "libzip-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "https://www.nih.at/libzip/${name}.tar.gz";
    sha256 = "1633dvjc08zwwhzqhnv62rjf1abx8y5njmm8y16ik9iwd07ka6d9";
  };

  postPatch = ''
    patchShebangs test-driver
    patchShebangs man/handle_links
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ perl ];
  propagatedBuildInputs = [ zlib ];

  preCheck = ''
    # regress/runtests is a generated file
    patchShebangs regress
  '';

  # At least mysqlWorkbench cannot find zipconf.h; I think also openoffice
  # had this same problem.  This links it somewhere that mysqlworkbench looks.
  postInstall = ''
    mkdir -p $dev/lib
    mv $out/lib/libzip $dev/lib/libzip
    ( cd $dev/include ; ln -s ../lib/libzip/include/zipconf.h zipconf.h )
  '';

  meta = with stdenv.lib; {
    homepage = https://www.nih.at/libzip;
    description = "A C library for reading, creating and modifying zip archives";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
