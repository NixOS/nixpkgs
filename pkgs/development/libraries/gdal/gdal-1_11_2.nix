{ stdenv, fetchurl, composableDerivation, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff, python, pythonPackages, proj, geos, openssl
, libpng }:

composableDerivation.composableDerivation {} (fixed: rec {
  version = "1.11.2";
  name = "gdal-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/gdal/${version}/${name}.tar.gz";
    sha256 = "66bc8192d24e314a66ed69285186d46e6999beb44fc97eeb9c76d82a117c0845";
  };

  buildInputs = [ unzip libjpeg libtiff libpng python pythonPackages.numpy proj openssl ];

  patches = [
    # This ensures that the python package is installed into gdal's prefix,
    # rather than trying to install into python's prefix.
    ./python.patch
  ];

  # Don't use optimization for gcc >= 4.3. That's said to be causing segfaults.
  # Unset CC and CXX as they confuse libtool.
  preConfigure = "export CFLAGS=-O0 CXXFLAGS=-O0; unset CC CXX";

  configureFlags = [
    "--with-jpeg=${libjpeg}"
    "--with-libtiff=${libtiff}" # optional (without largetiff support)
    "--with-libpng=${libpng}"   # optional
    "--with-libz=${zlib}"       # optional

    "--with-pg=${postgresql}/bin/pg_config"
    "--with-mysql=${mysql.lib}/bin/mysql_config"
    "--with-geotiff=${libgeotiff}"
    "--with-python"               # optional
    "--with-static-proj4=${proj}" # optional
    "--with-geos=${geos}/bin/geos-config"# optional
  ];

  # Prevent this:
  #
  #   Checking .pth file support in /nix/store/xkrmb8xnvqxzjwsdmasqmsdh1a5y2y99-gdal-1.11.2/lib/python2.7/site-packages/
  #   /nix/store/pbi1lgank10fy0xpjckbdpgacqw34dsz-python-2.7.9/bin/python -E -c pass
  #   TEST FAILED: /nix/store/xkrmb8xnvqxzjwsdmasqmsdh1a5y2y99-gdal-1.11.2/lib/python2.7/site-packages/ does NOT support .pth files
  #   error: bad install directory or PYTHONPATH
  preBuild = ''
    pythonInstallDir=$out/lib/${python.libPrefix}/site-packages
    mkdir -p $pythonInstallDir
    export PYTHONPATH=''${PYTHONPATH:+''${PYTHONPATH}:}$pythonInstallDir
  '';

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = http://www.gdal.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
})
