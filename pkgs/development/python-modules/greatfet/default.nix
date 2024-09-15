{
  buildPythonPackage,
  cmsis-svd,
  fetchFromGitHub,
  future,
  ipython,
  lib,
  prompt-toolkit,
  pyfwup,
  pygreat,
  pythonOlder,
  pyusb,
  setuptools,
  tabulate,
  tqdm,
}:

buildPythonPackage rec {
  pname = "greatfet";
  version = "2024.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "greatfet";
    rev = "refs/tags/v${version}";
    hash = "sha256-AKpaJZJTzMY3IQXLvVnLWh3IHeGp759z6tvaBl28BHQ=";
  };

  sourceRoot = "${src.name}/host";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    cmsis-svd
    future
    ipython
    prompt-toolkit
    pyfwup
    pygreat
    pyusb
    tabulate
    tqdm
  ];

  # Tests seem to require devices (or simulators) which are
  # not available in the build sandbox.
  doCheck = false;

  meta = {
    description = "Hardware hacking with the greatfet";
    homepage = "https://greatscottgadgets.com/greatfet";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "gf";
    maintainers = with lib.maintainers; [
      mog
      msanft
    ];
  };
}
