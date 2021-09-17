{ lib, stdenv, fetchzip, netcdf, netcdfcxx4, gsl, udunits, antlr2, which, curl, flex, coreutils }:

stdenv.mkDerivation rec {
  version = "5.0.1";
  pname = "nco";

  nativeBuildInputs = [ flex which antlr2 ];
  buildInputs = [ netcdf netcdfcxx4 gsl udunits curl coreutils ];

  src = fetchzip {
    url = "https://github.com/nco/nco/archive/${version}.tar.gz";
    sha256 = "sha256-Mdnko+0ZuMoKgBp//+rCVsbFJx90Tmrnal7FAmwIKEQ=";
  };

  prePatch = ''
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/cp" "${coreutils}/bin/cp"
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/mv" "${coreutils}/bin/mv"
  '';

  parallelBuild = true;

  meta = {
    description = "NetCDF Operator toolkit";
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    homepage = "http://nco.sourceforge.net/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
}
