{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  netcdf,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "netcdf";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-netcdf";
    tag = "v${version}";
    sha256 = "sha256-47+8daOrPjjsVWi6Sz2V/GNK4vQ5nbGCrQmgnZRap+k=";
  };

  propagatedBuildInputs = [
    netcdf
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/netcdf/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ravenjoad ];
    description = "NetCDF interface for Octave";
  };
}
