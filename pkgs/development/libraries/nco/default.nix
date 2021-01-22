{ lib, stdenv, fetchzip, netcdf, netcdfcxx4, gsl, udunits, antlr, which, curl, flex, coreutils }:

stdenv.mkDerivation rec {
  version = "4.9.7";
  pname = "nco";

  nativeBuildInputs = [ flex which ];
  buildInputs = [ netcdf netcdfcxx4 gsl udunits antlr curl coreutils ];

  src = fetchzip {
    url = "https://github.com/nco/nco/archive/${version}.tar.gz";
    sha256 = "sha256-Q4okOoyodofAsMrSmAhFISeY05Be+i7OX4qy2annQq4=";
  };

  prePatch = ''
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/cp" "${coreutils}/bin/cp"
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/mv" "${coreutils}/bin/mv"
  '';

  meta = {
    description = "NetCDF Operator toolkit";
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    homepage = "http://nco.sourceforge.net/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bzizou ];
    platforms = lib.platforms.linux;
  };
}
