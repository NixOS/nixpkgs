{
  buildOctavePackage,
  lib,
  fetchurl,
  cfitsio,
  hdf5,
  pkg-config,
}:

buildOctavePackage rec {
  pname = "fits";
  version = "1.0.7";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0jab5wmrpifqphmrfkqcyrlpc0h4y4m735yc3avqqjajz1rl24lm";
  };

  # Found here: https://build.opensuse.org/package/view_file/science/octave-forge-fits/octave-forge-fits.spec?expand=1
  patchPhase = ''
    sed -i -s -e 's/D_NINT/octave::math::x_nint/g' src/*.cc
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    hdf5
  ];

  propagatedBuildInputs = [
    cfitsio
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/fits/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Functions for reading, and writing FITS (Flexible Image Transport System) files using cfitsio";
    # Hasn't been updated since 2015, and fails to build with octave >= 10.1.0
    broken = true;
  };
}
