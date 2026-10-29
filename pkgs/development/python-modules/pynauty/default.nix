{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gnumake,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "pynauty";
  version = "2.8.8.1";

  __structuredAttrs = true;

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pdobsan";
    repo = "pynauty";
    tag = finalAttrs.version;
    hash = "sha256-VdAXNRRMNEos0t04ixQywUncj7ohSCqRDitT+kWywZo=";
  };

  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    gnumake
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlags = [
    "--pyargs"
    "pynauty"
  ];

  pythonImportsCheck = [
    "pynauty"
    "pynauty.nautywrap"
  ];

  meta = {
    description = "Isomorphism testing and automorphisms of graphs";
    homepage = "https://github.com/pdobsan/pynauty";
    changelog = "https://github.com/pdobsan/pynauty/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      asl20
    ];
    maintainers = with lib.maintainers; [ kilianar ];
  };
})
