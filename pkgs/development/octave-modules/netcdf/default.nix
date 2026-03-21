{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
  netcdf,
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "netcdf";
  version = "1.0.19";

  src = fetchFromGitHub {
    owner = "gnu-octave";
    repo = "octave-netcdf";
    tag = "v${version}";
    sha256 = "sha256-yt39bd6EBLj7mr6EYngPfPXEMusncc9tx5So1Cp1zkM=";
  };

  propagatedBuildInputs = [
    netcdf
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/netcdf/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "NetCDF interface for Octave";
  };
}
