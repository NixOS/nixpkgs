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
  version = "0-unstable-2025-02-07";
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
    rev = "6e01882eefd62cf19f5740406144632fe2d21947";
    # these files change depending on git branch status
    postFetch = "rm -f $out/.git_archival.txt $out/.gitattributes";
    hash = "sha256-U/+5v4wN+HfpWHnT9E9hf4XYpzqQQ7Tgq6Z09nEIBeE=";
  };

  build-system = [ pdm-backend ];
  dependencies = [ amaranth ];

  preBuild = ''
    export PDM_BUILD_SCM_VERSION="${realVersion}"
  '';

  # no tests
  doCheck = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Board definitions for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-boards";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      thoughtpolice
      pbsds
    ];
  };
}
