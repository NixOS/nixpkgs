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
  version = "0.5.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari";
    tag = "v${version}";
    hash = "sha256-nMGqsgE3IXyC8lcM9+3U7ytEgDeYsFEbkgByHI4xI0E=";
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

  dontUseSetuptoolsCheck = true;

  postFixup = ''
    wrapQtApp $out/bin/napari
  '';

  meta = {
    description = "Fast, interactive, multi-dimensional image viewer";
    homepage = "https://github.com/napari/napari";
    changelog = "https://github.com/napari/napari/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
