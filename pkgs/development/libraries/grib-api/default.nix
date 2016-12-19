{ fetchurl, stdenv, curl,
  netcdf, jasper, openjpeg }:

stdenv.mkDerivation rec{
  name = "grib-api-${version}";
  version = "1.14.4";

  src = fetchurl {
    url = https://software.ecmwf.int/wiki/download/attachments/3473437/grib_api-1.14.4-Source.tar.gz;
    sha256 = "1w8z9y79wakhwv1r4rb4dwlh9pbyw367klcm6laxz91hhvfrpfq8";
  };

  buildInputs = [ netcdf
                  jasper
                  openjpeg
                  curl     # Used for downloading during make test
                ];
  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://software.ecmwf.int/wiki/display/GRIB/Home";
    license = licenses.asl20;
    description = "ECMWF Library for the GRIB file format";
    longDescription = ''
      The ECMWF GRIB API is an application program interface accessible from C,
      FORTRAN and Python programs developed for encoding and decoding WMO FM-92
      GRIB edition 1 and edition 2 messages.
    '';

  };
}

