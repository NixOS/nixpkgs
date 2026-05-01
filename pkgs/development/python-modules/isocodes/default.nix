{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
  pyinstaller,
  busybox,
}:

buildPythonPackage (finalAttrs: {
  pname = "isocodes";
  version = "2025.8.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Atem18";
    repo = "isocodes";
    tag = finalAttrs.version;
    hash = "sha256-rGARvUNaTZ8/CuQ2vhPRx4whYty8lJLSE+5AZTS3eQw=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pyinstaller
    pytestCheckHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    busybox
  ];
  pythonImportsCheck = [ "isocodes" ];

  meta = {
    description = "This project provides lists of various ISO standards (e.g. country, language, language scripts, and currency names) in one place";
    homepage = "https://github.com/Atem18/isocodes";
    changelog = "https://github.com/Atem18/isocodes/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      gigahawk
    ];
  };
})
