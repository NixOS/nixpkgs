{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libjpeg_turbo,
  setuptools,
  numpy,
  pytest-memray,
  pytestCheckHook,
  replaceVars,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyturbojpeg";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilohuang";
    repo = "PyTurboJPEG";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sZB0BzgrA0I3GHtu5Z6cWpMQcE5Lqkvwix0ztbrWj3g=";
  };

  patches = [
    (replaceVars ./lib-path.patch {
      libturbojpeg = "${lib.getLib libjpeg_turbo}/lib/libturbojpeg${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-memray
    pytestCheckHook
  ];

  disabledTests = [
    # our patch breaks the test
    "test_library_loading_error_message"
  ];

  pythonImportsCheck = [ "turbojpeg" ];

  meta = {
    changelog = "https://github.com/lilohuang/PyTurboJPEG/releases/tag/${finalAttrs.src.tag}";
    description = "Python wrapper of libjpeg-turbo for decoding and encoding JPEG image";
    homepage = "https://github.com/lilohuang/PyTurboJPEG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
