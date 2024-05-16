{
  lib,
  app-model,
  appdirs,
  buildPythonPackage,
  cachey,
  certifi,
  dask,
  docstring-parser,
  fetchFromGitHub,
  imageio,
  jsonschema,
  magicgui,
  mkDerivationWith,
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
  pythonOlder,
  pyyaml,
  scikit-image,
  scipy,
  setuptools,
  setuptools-scm,
  superqt,
  tifffile,
  toolz,
  tqdm,
  typing-extensions,
  vispy,
  wrapQtAppsHook,
  wrapt,
}:

mkDerivationWith buildPythonPackage rec {
  pname = "napari";
  version = "0.4.19.post1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "napari";
    repo = "napari";
    rev = "refs/tags/v${version}";
    hash = "sha256-qw5WdFPySNkmm+dNu+hqsmr+csBpHnSl9bMpb4nKEqI=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "scikit-image[data]>=0.19.1" "scikit-image"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "A fast, interactive, multi-dimensional image viewer";
    homepage = "https://github.com/napari/napari";
    changelog = "https://github.com/napari/napari/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
