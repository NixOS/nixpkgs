args: with args;

let inherit (args.composableDerivation) composableDerivation edf wwf; in

composableDerivation {} ( fixed : {

  name = "gdal-1.7.1";


  src = fetchurl {
    url = ftp://ftp.remotesensing.org/gdal/gdal171.zip;
    md5 = "f5592cff69b239166c9b64ff81943b1a";
  };

  buildInputs = [unzip libjpeg];

  # don't use optimization for gcc >= 4.3. That's said to be causeing segfaults
  preConfigure = "export CFLAGS=-O0; export CXXFLAGS=-O0";

  configureFlags = [
    "--with-jpeg=${libjpeg}"
    "--with-libtiff=${libtiff}"  # optional (without largetiff support
    "--with-libz=${zlib}"        # optional

    "--with-pg=${postgresql}/bin/pg_config"
    "--with-mysql=${mysql}/bin/mysql_config"
    "--with-geotiff=${libgeotiff}"
  ];

  /* TODO
    # --with-grass=ARG      Include GRASS support (GRASS 5.7+, ARG=GRASS install tree dir)
    # --with-libgrass=ARG   Include GRASS support based on libgrass (GRASS 5.0+)
  --with-cfitsio=ARG    Include FITS support (ARG=no or libcfitsio path)
  --with-pcraster=ARG   Include PCRaster (libcsf) support (ARG=internal, no or path)
  --with-netcdf=ARG     Include netCDF support (ARG=no or netCDF tree prefix)
  --with-png=ARG        Include PNG support (ARG=internal, no or path)
  --with-pcidsk=ARG     Path to external PCIDSK SDK, or internal (default), or old
  --with-libtiff=ARG    Libtiff library to use (ARG=internal, yes or path)
  --with-jpeg=ARG       Include JPEG support (ARG=internal, no or path)
  --without-jpeg12        Disable JPEG 8/12bit TIFF support
  --with-gif=ARG        Include GIF support (ARG=internal, no or path)
  --with-ogdi=ARG       Include OGDI support (ARG=path)
  --with-fme=ARG        Include FMEObjects support (ARG=FME_HOME path)
  --with-hdf4=ARG       Include HDF4 support (ARG=path)
  --with-hdf5=ARG       Include HDF5 support (ARG=path)
  --with-jasper=ARG     Include JPEG-2000 support via JasPer library (ARG=path)
  --with-ecw=ARG        Include ECW support (ARG=ECW SDK Path, yes or no)
  --with-kakadu=ARG     Include Kakadu/JPEG2000 support
  --with-mrsid=ARG      Include MrSID support (ARG=path to MrSID DSDK or no)
  --with-jp2mrsid=ARG   Enable MrSID JPEG2000 support (ARG=yes/no)
  --with-msg=ARG          Enable MSG driver (ARG=yes or no)
  --without-bsb           Disable BSB driver (legal issues pending
  --with-oci=[ARG]        use Oracle OCI API from given Oracle home
                          (ARG=path); use existing ORACLE_HOME (ARG=yes);
                          disable Oracle OCI support (ARG=no)
  --with-oci-include=[DIR]
                          use Oracle OCI API headers from given path
  --with-oci-lib=[DIR]    use Oracle OCI API libraries from given path
  --without-grib          Disable GRIB driver
  --without-ogr         Don't build OGR into shared library
  --with-ingres=ARG     Include Ingres (ARG=$II_SYSTEM)
  --with-xerces=[ARG]     use Xerces C++ Parser from given prefix (ARG=path);
                          check standard prefixes (ARG=yes); disable (ARG=no)
  --with-xerces-inc=[DIR] path to Xerces C++ Parser headers
  --with-xerces-lib=[ARG] link options for Xerces C++ Parser libraries
  --with-expat=[ARG]      use Expat XML Parser from given prefix (ARG=path);
                          check standard prefixes (ARG=yes); disable (ARG=no)
  --with-expat-inc=[DIR]  path to Expat XML Parser headers
  --with-expat-lib=[ARG]  link options for Expat XML Parser libraries
  --with-odbc=ARG       Include ODBC support (ARG=no or path)
  --with-dods-root=ARG  Include DODS support (ARG=no or absolute path)
  --with-curl=ARG       Include curl (ARG=path to curl-config.)
  --with-spatialite=ARG Include SpatiaLite support (ARG=no or path)
  --with-sqlite3=[ARG]    use SQLite 3 library [default=yes], optionally
                          specify the prefix for sqlite3 library
  --with-dwgdirect=path Include DWG direct support
  --with-dwg-plt=platform DWGdirect Platform, defaults to lnxX86
  --with-idb=DIR        Include Informix DataBlade support (DIR points to Informix root)
  --with-sde=DIR        Include ESRI SDE support (DIR is SDE's install dir).
  --with-sde-version=VERSION NUMBER  Set ESRI SDE version number (Default is 80).
  --without-vfk         Disable VFK support
  --with-epsilon=ARG    Include EPSILON support (ARG=no, yes or libepsilon install root path)
  --with-geos=ARG         Include GEOS support (ARG=yes, no or geos-config
                          path)
  --without-pam         Disable PAM (.aux.xml) support
  --with-static-proj4=ARG Compile with PROJ.4 statically (ARG=no or path)
  --with-gdal-ver=ARG   Override GDAL version
  --with-macosx-framework         Build and install GDAL as a Mac OS X Framework
  --with-perl           Enable perl bindings
  --with-php            Enable php bindings
  --with-ruby           Enable Ruby bindings
  --with-python       Enable python bindings
  --with-pymoddir=ARG   Override Old-gen Python package install dir

  */

  meta = {
    description = "translator library for raster geospatial data formats";
    homepage = http://www.gdal.org/;
    license = "X/MIT";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
})
