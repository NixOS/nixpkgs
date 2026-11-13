{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  amaranth,
  pdm-backend,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "amaranth-boards";
  version = "0-unstable-2026-08-13";
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
    repo = "amaranth-boards";
    rev = "f270d210e36b0787d62db77176c7b0e8032178d3";
    # these files change depending on git branch status
    postFetch = "rm -f $out/.git_archival.txt $out/.gitattributes";
    hash = "sha256-AeHydgyEm0kl6Z12Hvc8b2kwSKp5dNbZlDwZXLN78v4=";
  };

  build-system = [ pdm-backend ];
  dependencies = [ amaranth ];

  preBuild = ''
    export PDM_BUILD_SCM_VERSION="${realVersion}"
  '';

  # no tests
  doCheck = false;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Board definitions for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-boards";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      thoughtpolice
      pbsds
    ];
  };
}
