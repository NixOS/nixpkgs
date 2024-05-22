{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  amaranth,
  pdm-backend,
}:

buildPythonPackage rec {
  pname = "amaranth-soc";
  version = "0-unstable-2024-02-16";
  pyproject = true;
  # from `pdm show`
  realVersion = "0.1a1.dev1+g${lib.substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner = "amaranth-lang";
    repo = "amaranth-soc";
    rev = "9f46553aa4289e2a11788a73fade6410a371b162";
    hash = "sha256-ZllDSrZEu16jZtbQ7crQSj3XCbsthueXtaAvyf45dmY=";
  };

  nativeBuildInputs = [ pdm-backend ];
  dependencies = [ amaranth ];

  preBuild = ''
    export PDM_BUILD_SCM_VERSION="${realVersion}"
  '';

  meta = with lib; {
    description = "System on Chip toolkit for Amaranth HDL";
    homepage = "https://github.com/amaranth-lang/amaranth-soc";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      emily
      thoughtpolice
      pbsds
    ];
  };
}
