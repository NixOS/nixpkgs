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
  version = "0.1a-unstable-2024-10-12";
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
    rev = "5c43cf58f15d9cd9c69ff83c97997708d386b2dc";
    hash = "sha256-o9xjH/nmV7ovw6bQ6PaFGLcjz5gDGb+eQ9eGNRPnBV8=";
  };

  build-system = [ pdm-backend ];
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
