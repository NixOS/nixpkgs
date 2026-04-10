{
  buildPythonPackage,
  cmsis-svd,
  fetchFromGitHub,
  fetchPypi,
  ipython,
  lib,
  prompt-toolkit,
  pyfwup,
  pygreat,
  pyusb,
  setuptools,
  tabulate,
  tqdm,
  unzip,
}:

buildPythonPackage rec {
  pname = "greatfet";
  version = "2026.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "greatfet";
    tag = "v${version}";
    hash = "sha256-qXPNatakMVtvl26FG1bx+ngCeqRpg1So6qFamKK8WWk=";
  };

  # The prebuilt LPC firmware image (greatfet_usb.bin) and the DFU recovery
  # stub (flash_stub.bin) are release artifacts cross-compiled from firmware/.
  # They are absent from the git checkout (their build inputs are now-empty
  # submodules) but are shipped in the upstream wheel. Without them
  # `greatfet_firmware --autoflash` and DFU-mode firmware recovery are
  # unavailable, so vendor them from the wheel to match `pip install greatfet`.
  firmwareAssets = fetchPypi {
    inherit pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-sH1FAkfdC0HxRLZjfx7b2AYWMh4rtSijFgsU/YnVKq0=";
  };

  sourceRoot = "${src.name}/host";

  nativeBuildInputs = [ unzip ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<2"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'

    # Restore the prebuilt firmware images shipped in the upstream wheel; the
    # existing MANIFEST.in (recursive-include greatfet/assets *) then packages
    # them into greatfet/assets/ where find_greatfet_asset() looks at runtime.
    unzip -j -o ${firmwareAssets} \
      'greatfet/assets/greatfet_usb.bin' \
      'greatfet/assets/flash_stub.bin' \
      -d greatfet/assets/
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "ipython" ];

  dependencies = [
    cmsis-svd
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
