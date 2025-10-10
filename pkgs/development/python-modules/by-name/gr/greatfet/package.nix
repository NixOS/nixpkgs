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
  version = "2024.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "greatfet";
    tag = "v${version}";
    hash = "sha256-3ClM4UzVIDEkVBrFwzvLokbxUHXqdQWyNVqcFtiXCOQ=";
  };

  sourceRoot = "${src.name}/host";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "ipython" ];

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
