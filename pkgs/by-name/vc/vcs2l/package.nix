{
  lib,
  python3Packages,
  fetchPypi,
  git,
  breezy,
  subversion,
  nix-update-script,
}:

with python3Packages;

buildPythonApplication (finalAttrs: {
  pname = "vcs2l";
  version = "1.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "1d86e685f9e01dda271b89df1b2bd42ca5555f5c0dcbef5cc727d443f25738cd";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = [
    pyyaml
    setuptools # pkg_resources is imported during runtime
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      git
      breezy
      subversion
    ])
  ];

  doCheck = false; # requires network

  pythonImportsCheck = [ "vcs2l" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Provides a command line tool to invoke vcs commands on multiple repositories";
    homepage = "https://github.com/ros-infrastructure/vcs2l";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      esteve
      sivteck
    ];
  };
})
