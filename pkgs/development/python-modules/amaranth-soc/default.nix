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
  version = "0.1a-unstable-2024-06-10";
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
    rev = "e1b842800533f44924f21c3867bc2290084d100f";
    hash = "sha256-GAGQEncONY566v8hLjGeZ7CRlOt36vHg+0a5xcB+g1Y=";
  };

  nativeBuildInputs = [ pdm-backend ];
  dependencies = [ amaranth ];

  preBuild = ''
    export PDM_BUILD_SCM_VERSION="${realVersion}"
  '';

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = with lib; {
    description = "System on Chip toolkit for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-soc";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      thoughtpolice
      pbsds
    ];
  };
}
