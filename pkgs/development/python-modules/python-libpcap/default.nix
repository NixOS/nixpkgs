{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-libpcap";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "caizhengxin";
    repo = "python-libpcap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bml9BYr3VfbKAaHN7OZYLNCNwn+ldE+jrKNzjvdYtMA=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ libpcap ];

  pythonImportsCheck = [ "pylibpcap" ];

  # Tests require network access
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cython libpcap";
    homepage = "https://github.com/caizhengxin/python-libpcap";
    changelog = "https://github.com/caizhengxin/python-libpcap/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
