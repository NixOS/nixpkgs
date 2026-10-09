{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "zk-graph-view";
  version = "0.2.0";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyberSapoPerro";
    repo = "zk-graph-view";
    rev = "75f8e519a3acd945e4629cc7789e967386473cf2";
    hash = "sha256-mTC4eABtm3YecWE0euWmmRcN1wta0IaEcP0X0OhruCM=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    numpy
    pyvis
    scipy
    matplotlib
    colorir
  ];

  # typing is a deprecated dependency, as it is now part of the standard library.
  # needs to be fixed upstream
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"typing",' ""
  '';

  meta = {
    description = "Interactive visualization of Zettelkasten graphs generated with zk";
    homepage = "https://github.com/cyberSapoPerro/zk-graph-view";
    license = lib.licenses.mit;
    mainProgram = "zk-graph-view";
    maintainers = with lib.maintainers; [
      dccabanas
    ];
  };
}
