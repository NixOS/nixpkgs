{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  importlib-metadata,
  natsort,
  pillow,
  py7zr,
  pycountry,
  pyicu,
  pytestCheckHook,
  pythonOlder,
  rapidfuzz,
  rarfile,
  setuptools,
  setuptools-scm,
  text2digits,
  wheel,
  wordninja,
}:

buildPythonPackage rec {
  pname = "comicapi";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "comictagger";
    repo = "comicapi";
    rev = "2bf8332114e49add0bbc0fd3d85bdbba02de3d1a";
    hash = "sha256-Cd3ILy/4PqWUj1Uu9of9gCpdVp2R6CXjPOuSXgrB894=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [
    importlib-metadata
    natsort
    pillow
    pycountry
    rapidfuzz
    text2digits
    wordninja
  ];

  optional-dependencies = {
    _7z = [ py7zr ];

    all = [
      py7zr
      rarfile
    ]
    ++ lib.optional (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) pyicu;

    cbr = [ rarfile ];

    icu = lib.optional (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) pyicu;
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonRelaxDeps = [ "pycountry" ];

  disabledTests = [
    # AssertionError
    "test_copy_from_archive"
  ];

  pythonImportsCheck = [ "comicapi" ];

  meta = {
    description = "Comic archive (cbr/cbz/cbt) and metadata utilities";
    homepage = "https://github.com/comictagger/comicapi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
