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
}:

mkDerivationWith buildPythonPackage rec {
  pname = "napari";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari";
    tag = "v${version}";
    hash = "sha256-p6deNHnlvgZXV3Ym3OADC44j5bOkMDjlmM2N3yE5GxE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "scikit-image[data]>=0.19.1" "scikit-image"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

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
  ] ++ dask.optional-dependencies.array;

  postFixup = ''
    wrapQtApp $out/bin/napari
  '';

  meta = {
    description = "Fast, interactive, multi-dimensional image viewer";
    homepage = "https://github.com/napari/napari";
    changelog = "https://github.com/napari/napari/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
