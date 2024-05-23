{ lib
, stdenv
, fetchFromGitHub

  # By default, no grids packages are installed due to a large size of this
  # repository. Current size of all proj-data grids is almost 1GB and will only
  # grow over the time.
, gridPackages ? [ ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proj-data";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ-data";
    rev = finalAttrs.version;
    hash = "sha256-/EgDeWy2+KdcI4DLsRfWi5OWcGwO3AieEJQ5Zh+wdYE=";
  };

  installPhase = ''
    runHook preInstall
    shopt -s extglob

    mkdir -p $out
    cp README.DATA $out/README-PROJ-DATA.md

    for grid in ${builtins.toString gridPackages}; do
      if [ ! -d $grid ]; then
        echo "ERROR: proj-data grid $grid does not exist." >&2
        exit 1
      fi

      cp $grid/!(*.sh|*.py) $out/
    done

    shopt -u extglob
    runHook postInstall
  '';

  meta = with lib; {
    description = "Repository for proj datum grids (for use by PROJ 7 or later)";
    homepage = "https://proj4.org";
    # Licensing note:
    # All grids in the package are released under permissive licenses. New grids
    # are accepted into the package as long as they are released under a license that
    # is compatible with the Open Source Definition and the source of the grid is
    # clearly stated and verifiable. Suitable licenses include:
    # Public domain
    # X/MIT
    # BSD 2/3/4 clause
    # CC0
    # CC-BY (v3.0 or later)
    # CC-BY-SA (v3.0 or later)
    license = licenses.mit;
    maintainers = teams.geospatial.members;
  };
})
