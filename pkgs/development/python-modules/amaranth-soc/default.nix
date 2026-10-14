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
  version = "0.1a-unstable-2026-05-23";
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
    rev = "3e3d8b7241c1c7e80e0cd12937d288d0ad4a6cba";
    hash = "sha256-GuunBRGQpMSJWWU6ukr9FYTpPDIxsTyLz7j9iQgN900=";
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
