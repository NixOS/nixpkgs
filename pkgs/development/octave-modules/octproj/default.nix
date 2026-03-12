{
  buildOctavePackage,
  lib,
  fetchFromBitbucket,
  proj, # >= 6.3.0
  nix-update-script,
}:

buildOctavePackage rec {
  pname = "octproj";
  version = "3.1.0";

  src = fetchFromBitbucket {
    owner = "jgpallero";
    repo = "octproj";
    rev = "OctPROJ-${version}";
    sha256 = "sha256-0QDlpfqFTSndUPkOslugDBM0UBKiusZwKGFuDrco7X4=";
  };

  # The sed changes below allow for the package to be compiled.
  patchPhase = ''
    sed -i s/"error(errorText)"/"error(\"%s\", errorText)"/g src/*.cc
    sed -i s/"warning(errorText)"/"warning(\"%s\", errorText)"/g src/*.cc
  '';

  propagatedBuildInputs = [
    proj
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "OctPROJ-(.*)"
    ];
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/octproj/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "GNU Octave bindings to PROJ library for cartographic projections and CRS transformations";
  };
}
