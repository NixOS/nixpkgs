{ stdenv, fetchurl, composableDerivation, unzip, libjpeg, libtiff, zlib
, postgresql, mysql, libgeotiff, pythonPackages, proj, geos, openssl
, libpng }:

composableDerivation.composableDerivation {} (fixed: rec {
  version = "2.0.1";
  name = "gdal-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/gdal/${version}/${name}.tar.gz";
    sha256 = "b55f794768e104a2fd0304eaa61bb8bda3dc7c4e14f2c9d0913baca3e55b83ab";
  };

  buildInputs = [ unzip libjpeg libtiff libpng proj openssl ]
  ++ (with pythonPackages; [ python numpy wrapPython ]);

  hardening_format = false;

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
    pythonInstallDir=$out/lib/${pythonPackages.python.libPrefix}/site-packages
    mkdir -p $pythonInstallDir
    export PYTHONPATH=''${PYTHONPATH:+''${PYTHONPATH}:}$pythonInstallDir
  '';

  postInstall = ''
    wrapPythonPrograms
  '';

  meta = {
    description = "Translator library for raster geospatial data formats";
    homepage = http://www.gdal.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
})
