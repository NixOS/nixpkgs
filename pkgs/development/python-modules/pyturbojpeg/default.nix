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

buildPythonPackage rec {
  pname = "pyturbojpeg";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilohuang";
    repo = "PyTurboJPEG";
    tag = "v${version}";
    hash = "sha256-rMn5NmiwKhyj4U9kyyRf9ZheVnETpixZoL/AVlBlImQ=";
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
    changelog = "https://github.com/lilohuang/PyTurboJPEG/releases/tag/${src.tag}";
    description = "Python wrapper of libjpeg-turbo for decoding and encoding JPEG image";
    homepage = "https://github.com/lilohuang/PyTurboJPEG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
