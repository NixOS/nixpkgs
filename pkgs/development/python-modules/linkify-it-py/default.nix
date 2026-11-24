{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-timeout,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "linkify-it-py";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsutsu3";
    repo = "linkify-it-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uFZBEBlM5IDN64ZydeNsUAZ2ssO4XRFPqPv5RoKEWwY=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "linkify_it" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
  ];

  meta = {
    changelog = "https://github.com/tsutsu3/linkify-it-py/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Links recognition library with full unicode support";
    homepage = "https://github.com/tsutsu3/linkify-it-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ colinxu2020 ];
  };
})
