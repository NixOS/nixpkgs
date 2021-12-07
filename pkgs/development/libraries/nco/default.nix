{ lib, stdenv, fetchFromGitHub, netcdf, netcdfcxx4, gsl, udunits, antlr2, which, curl, flex, coreutils }:

stdenv.mkDerivation rec {
  pname = "nco";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "nco";
    repo = "nco";
    rev = version;
    sha256 = "sha256-hE3TSfZoKqiUEcLO+Q3xAjhyDPNqoq7+FGlKNpm8hjY=";
  };

  nativeBuildInputs = [ flex which antlr2 ];

  buildInputs = [ netcdf netcdfcxx4 gsl udunits curl coreutils ];

  postPatch = ''
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/cp" "${coreutils}/bin/cp"
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/mv" "${coreutils}/bin/mv"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "NetCDF Operator toolkit";
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    homepage = "http://nco.sourceforge.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
    platforms = platforms.linux;
  };
}
