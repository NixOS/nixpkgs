{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "virtme-ng";
  version = "1.41";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arighi";
    repo = "virtme-ng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/R+2ND/N+exF9eDSxAN8LR3cDuxBvpGSkiXcckyq8TY=";
    fetchSubmodules = true;
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    argcomplete
    argparse-manpage
    requests
    setuptools
  ];

  optional-dependencies = with python3Packages; {
    mcp = [
      anyio
      mcp
    ];
  };

  pythonImportsCheck = [
    "virtme_ng"
  ];

  meta = {
    description = "Quickly build and run kernels inside a virtualized snapshot of your live system";
    longDescription = ''
      virtme-ng is a tool that allows to easily and quickly recompile and test
      a Linux kernel, starting from the source code.

      It allows recompiling the kernel in few minutes (rather than hours), then
      the kernel is automatically started in a virtualized environment that is
      an exact copy-on-write copy of your live system, which means that any
      changes made to the virtualized environment do not affect the host
      system.
    '';
    homepage = "https://github.com/arighi/virtme-ng";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ eljamm ];
    mainProgram = "virtme-ng";
  };
})
