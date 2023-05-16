<<<<<<< HEAD
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
  version = "5.1.7";
=======
{ lib, stdenv, fetchFromGitHub, netcdf, netcdfcxx4, gsl, udunits, antlr2, which, curl, flex, coreutils, libtool }:

stdenv.mkDerivation rec {
  pname = "nco";
  version = "5.1.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nco";
    repo = "nco";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-CdIZ0ql8QBM7UcEyTmt4P9gZyO8jrkLipAOsJUkpG8g=";
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
=======
    rev = version;
    sha256 = "sha256-L1aAACWDVrPdl8IHSpch3l8EhdjAxOcUAZchKMYKWqY=";
  };

  nativeBuildInputs = [ flex which antlr2 ];

  buildInputs = [ netcdf netcdfcxx4 gsl udunits curl coreutils ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/cp" "${coreutils}/bin/cp"
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    substituteInPlace src/nco/nco_fl_utl.c \
      --replace "/bin/mv" "${coreutils}/bin/mv"
  '';

  makeFlags = lib.optionals stdenv.isDarwin [ "LIBTOOL=${libtool}/bin/libtool" ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "NetCDF Operator toolkit";
    homepage = "https://nco.sourceforge.net/";
    license = lib.licenses.bsd3;
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    maintainers = with lib.maintainers; [ bzizou ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    description = "NetCDF Operator toolkit";
    longDescription = "The NCO (netCDF Operator) toolkit manipulates and analyzes data stored in netCDF-accessible formats, including DAP, HDF4, and HDF5";
    homepage = "https://nco.sourceforge.net/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
