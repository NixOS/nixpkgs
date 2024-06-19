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
  version = "0.1a-unstable-2024-05-17";
  pyproject = true;
  # from `pdm show`
  realVersion = let
     tag = builtins.elemAt (lib.splitString "-" version) 0;
     rev = lib.substring 0 7 src.rev;
    in "${tag}1.dev1+g${rev}";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth-soc";
    rev = "45ff663b83694b09b2b8f3fc0f10c555a12ba987";
    hash = "sha256-Ql8XYC13wscPL96HY0kXselq78D747BpLK8X1sxpwz0=";
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
