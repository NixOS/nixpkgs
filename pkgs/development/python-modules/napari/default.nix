{
  lib,
  mkDerivationWith,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  wrapQtAppsHook,

  # dependencies
  app-model,
  appdirs,
  cachey,
  certifi,
  dask,
  docstring-parser,
  imageio,
  jsonschema,
  magicgui,
  napari-console,
  napari-npe2,
  napari-svg,
  numpydoc,
  pandas,
  pillow,
  pint,
  psutil,
  pydantic,
  pyopengl,
  pyyaml,
  scikit-image,
  scipy,
  superqt,
  tifffile,
  toolz,
  tqdm,
  typing-extensions,
  vispy,
  wrapt,

  # tests
  hypothesis,
  pretend,
  pyautogui,
  pytest-pretty,
  pytest-qt,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  xarray,
  zarr,
}:

mkDerivationWith buildPythonPackage rec {
  pname = "napari";
  version = "0.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari";
    tag = "v${version}";
    hash = "sha256-F0l6GWyZ6n4HNZW7XyUk4ZBPQfrAW4DWixCaRHViDPI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"--maxfail=5", ' ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  pythonRelaxDeps = [
    "app-model"
    "psygnal"
    "vispy"
  ];
  dependencies = [
    app-model
    appdirs
    cachey
    certifi
    dask
    docstring-parser
    imageio
    jsonschema
    magicgui
    napari-console
    napari-npe2
    napari-svg
    numpydoc
    pandas
    pillow
    pint
    psutil
    pydantic
    pyopengl
    pyyaml
    scikit-image
    scipy
    superqt
    tifffile
    toolz
    tqdm
    typing-extensions
    vispy
    wrapt
  ]
  ++ dask.optional-dependencies.array;

  postFixup = ''
    wrapQtApp $out/bin/napari
  '';

  preCheck = ''
    rm src/napari/__init__.py
  '';

  nativeCheckInputs = [
    hypothesis
    pretend
    pyautogui
    pytest-pretty
    pytest-qt
    pytestCheckHook
    writableTmpDirAsHomeHook
    xarray
    zarr
  ];

  disabledTestPaths = [
    # Require DISPLAY access
    "src/napari/_qt/"

    # AttributeError: 'Selection' object has no attribute 'replace_selection'
    "src/napari/layers/shapes/_tests/test_shapes_mouse_bindings.py"
    "src/napari/layers/shapes/_tests/test_shapes.py"

    # Fatal Python error: Aborted
    "src/napari/_tests/test_adding_removing.py"
    "src/napari/_vispy/"
  ];

  disabledTests = [
    # Failed: DID NOT WARN. No warnings of type (<class 'FutureWarning'>,) were emitted.
    "test_PublicOnlyProxy"

    # NameError: name 'utils' is not defined
    "test_create_func_deprecated"
    "test_create_func_renamed"
    "test_create_func"
  ];

  meta = {
    description = "Fast, interactive, multi-dimensional image viewer";
    homepage = "https://github.com/napari/napari";
    changelog = "https://github.com/napari/napari/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
