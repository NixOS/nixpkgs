{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchzip,
  pkg-config,
  setuptools,
  autoreconfHook,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "libpff-python";
  version = "20260926";
  pyproject = true;
  __structuredAttrs = true;

  # fetchzip is used to get the full source of libpff, as dependencies are
  # only provided inside libpff release tarball.
  # fetchFromGitHub is used to get test data, as there are not provided
  # inside release tarball.
  srcs = [
    (fetchzip {
      name = "libpff-release";
      url = "https://github.com/libyal/libpff/releases/download/${finalAttrs.version}/libpff-alpha-${finalAttrs.version}.tar.gz";
      hash = "sha256-4lddoTUBmGXBFx1fvuki0IYxpal+pR6JC808ctFcckw=";
    })
    (fetchFromGitHub {
      name = "libpff-testdata";
      owner = "libyal";
      repo = "testdata";
      rev = "f018eb7c91c8356123b021ecd28ae894dd500210";
      hash = "sha256-YiEw0JZxFnKJGEsu+qZZnisHjafUA2HFloPlDH8j0d4=";
    })
  ];

  sourceRoot = "libpff-release";

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
    "-p"
    "'pypff*.py'"
  ];

  pythonImportsCheck = [
    "pypff"
  ];

  postUnpack = ''
    cp libpff-testdata/pst/outlook.pst libpff-release/testdata.pst
  '';

  preConfigure = ''
    cat pyproject.toml.in | \
      sed 's/@VERSION@/${finalAttrs.version}/' > pyproject.toml
  '';

  preCheck = ''
    substituteInPlace tests/pypff*.py \
      --replace-fail 'getattr(unittest, "source", None)' "'$(pwd)/testdata.pst'"
  '';

  meta = {
    description = "Library and tools to access the Personal Folder File (PFF) and the Offline Folder File (OFF) format";
    homepage = "https://github.com/libyal/libpff";
    downloadPage = "https://github.com/libyal/libpff/releases";
    changelog = "https://github.com/libyal/libpff/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
})
