{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  amaranth,
  pdm-backend,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "amaranth-soc";
  version = "0.1a-unstable-2026-01-28";
  pyproject = true;
  # from `pdm show`
  realVersion =
    let
      tag = builtins.elemAt (lib.splitString "-" version) 0;
      rev = lib.substring 0 7 src.rev;
    in
    "${tag}1.dev1+g${rev}";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth-soc";
    rev = "12a83ad650ae88fcc1b0821a4bb6f4bbf7e19707";
    hash = "sha256-qW2Uie4E/PeIHjTCEnnZwBO3mv4UBMH+vlYK+fHFh+Q=";
  };

  build-system = [ pdm-backend ];
  dependencies = [ amaranth ];

  preBuild = ''
    export PDM_BUILD_SCM_VERSION="${realVersion}"
  '';

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    description = "System on Chip toolkit for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-soc";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      thoughtpolice
      pbsds
    ];
  };
}
