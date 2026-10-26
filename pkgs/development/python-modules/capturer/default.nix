{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  humanfriendly,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "capturer";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-capturer";
    rev = finalAttrs.version;
    hash = "sha256-Qcr94MbNnqYlk6yeBmyWpqBwG+TbnclasfG/RIDqmTs=";
  };

  patches = [
    # https://github.com/xolox/python-capturer/pull/16
    (fetchpatch {
      name = "python314-compat.patch";
      url = "https://github.com/xolox/python-capturer/commit/3d0a9a040ecaa78ce2d39ec76ff5084ee7be6653.patch";
      hash = "sha256-NW+X6wdXMHSLswO7M7/YeIyHu+EDYTLJE/mBkqyhKUM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ humanfriendly ];

  # hangs on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Easily capture stdout/stderr of the current process and subprocesses";
    homepage = "https://github.com/xolox/python-capturer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
})
