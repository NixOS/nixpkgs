{ antlr2
, coreutils
, curl
, fetchFromGitHub
, flex
, gsl
, lib
, libtool
, netcdf
, netcdfcxx4
, stdenv
, udunits
, which
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nco";
  version = "5.1.9";

  src = fetchFromGitHub {
    owner = "nco";
    repo = "nco";
    rev = finalAttrs.version;
    hash = "sha256-D7WmJ53oK4craLx6PKAFA6Ue7wl5fRYPeEFeh78Kpdg=";
  };

  nativeBuildInputs = [
    antlr2
    flex
    which
  ];

  buildInputs = [
    coreutils
    curl
    gsl
    netcdf
    netcdfcxx4
    udunits
  ];

  postPatch = ''
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/cp" "${coreutils}/bin/cp"

    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/mv" "${coreutils}/bin/mv"
  '';

  makeFlags = lib.optionals stdenv.isDarwin [ "LIBTOOL=${libtool}/bin/libtool" ];

  enableParallelBuilding = true;

  meta = {
    description = "NetCDF Operator toolkit";
    homepage = "https://nco.sourceforge.net/";
    license = lib.licenses.bsd3;
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    maintainers = with lib.maintainers; [ bzizou ];
    platforms = lib.platforms.unix;
  };
})
