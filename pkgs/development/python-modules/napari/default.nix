{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # nativeBuildInputs
  qt6,

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

buildPythonPackage (finalAttrs: {
  pname = "napari";
  version = "0.6.6";
  pyproject = true;

  # napari uses pydantic v1 which is not compatible with python 3.14
  # ValueError: '__slots__' in __slots__ conflicts with class variable
  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari";
    tag = "v${finalAttrs.version}";
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

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [
    qt6.qtbase
  ];

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
    "src/napari/layers/shapes/_tests/test_shapes.py"
    "src/napari/layers/shapes/_tests/test_shapes_key_bindings.py"
    "src/napari/layers/shapes/_tests/test_shapes_mouse_bindings.py"

    # Fatal Python error: Aborted
    "src/napari/_tests/test_adding_removing.py"
    "src/napari/_tests/test_advanced.py"
    "src/napari/_tests/test_cli.py"
    "src/napari/_tests/test_conftest_fixtures.py"
    "src/napari/_tests/test_function_widgets.py"
    "src/napari/_tests/test_key_bindings.py"
    "src/napari/_tests/test_layer_utils_with_qt.py"
    "src/napari/_tests/test_mouse_bindings.py"
    "src/napari/_tests/test_multiple_viewers.py"
    "src/napari/_tests/test_notebook_display.py"
    "src/napari/_tests/test_top_level_availability.py"
    "src/napari/_tests/test_with_screenshot.py"
    "src/napari/_vispy/"
  ];

  enabledTestPaths = [
    "src/napari/_tests/"
  ];

  disabledTests = [
    # Failed: DID NOT WARN. No warnings of type (<class 'FutureWarning'>,) were emitted.
    "test_PublicOnlyProxy"

    # NameError: name 'utils' is not defined
    "test_create_func_deprecated"
    "test_create_func_renamed"
    "test_create_func"

    # AttributeError: 'Selection' object has no attribute 'replace_selection'
    "test_add_empty_shapes_layer"
    "test_update_data_updates_layer_extent_cache"

    # Fatal Python error: Aborted
    "test_add_layer_data_to_viewer_optional"
    "test_from_layer_data_tuple_accept_deprecating_dict"
    "test_layers_populate_immediately"
    "test_magicgui_add_data"
    "test_magicgui_add_future_data"
    "test_magicgui_add_layer"
    "test_magicgui_add_layer_inheritance"
    "test_magicgui_add_threadworker"
    "test_magicgui_data_updated"
    "test_magicgui_get_data"
    "test_magicgui_get_viewer"
    "test_make_napari_viewer"
    "test_singlescreen_window_settings"
    "test_sys_info"
    "test_view"
  ];

  meta = {
    description = "Fast, interactive, multi-dimensional image viewer";
    homepage = "https://github.com/napari/napari";
    changelog = "https://github.com/napari/napari/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
})
