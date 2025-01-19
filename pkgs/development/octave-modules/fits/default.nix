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

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/fits/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Functions for reading, and writing FITS (Flexible Image Transport System) files using cfitsio";
  };
}
