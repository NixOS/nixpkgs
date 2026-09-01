{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  ipython,
  numpy,
  pyserial,
  pytestCheckHook,
  pyusb,
  setuptools,
  udevCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rfcat";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atlas0fd00m";
    repo = "rfcat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nkm+TECg39PRygcS4PqIUY3ckJHdGbV+qcMFJvTDWcs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'RFCAT_VERSION,' '"${finalAttrs.version}",'
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ udevCheckHook ];

  dependencies = [
    ipython
    numpy
    pyserial
    pyusb
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/etc/udev/rules.d
    cp etc/udev/rules.d/20-rfcat.rules $out/etc/udev/rules.d
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "rflib" ];

  meta = {
    description = "Swiss Army knife of sub-GHz ISM band radio";
    homepage = "https://github.com/atlas0fd00m/rfcat";
    changelog = "https://github.com/atlas0fd00m/rfcat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "rfcat";
  };
})
