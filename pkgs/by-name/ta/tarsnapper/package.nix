{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  tarsnap,
}:

python3Packages.buildPythonApplication rec {
  pname = "tarsnapper";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miracle2k";
    repo = "tarsnapper";
    rev = version;
    hash = "sha256-5i9eum9hbh6VFhvEIDq5Uapy6JtIbf9jZHhRYZVoC1w=";
  };

  patches = [
    # Fix failing tests when default_deltas is None
    (fetchpatch {
      url = "https://github.com/miracle2k/tarsnapper/commit/2ee33ce748b9bb42d559cc2c0104115732cb4150.patch";
      hash = "sha256-fEXGhzlfB+J5lw1pcsC5Ne7I8UMnDzwyyCx/zm15+fU=";
    })
    # Migrate to pytest, see: https://github.com/miracle2k/tarsnapper/pull/73
    (fetchpatch {
      url = "https://github.com/miracle2k/tarsnapper/commit/eace01f3085fba8a6421d4f19110b814511e5170.patch?full_index=1";
      hash = "sha256-2YPb7iaAusT1DkISfOWs72jr/GBY/qG5qFyRlnVt0IY=";
    })
  ];

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    pyyaml
    python-dateutil
    pexpect
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # Remove standard module argparse from requirements
  pythonRemoveDeps = [ "argparse" ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ tarsnap ]}" ];

  pythonImportsCheck = [ "tarsnapper" ];

  meta = with lib; {
    description = "Wrapper which expires backups using a gfs-scheme";
    homepage = "https://github.com/miracle2k/tarsnapper";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gmacon ];
    mainProgram = "tarsnapper";
  };
}
