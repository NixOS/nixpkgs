{ lib
, mkDerivationWith
, appdirs
, buildPythonPackage
, cachey
, dask
, docstring-parser
, fetchFromGitHub
, imageio
, jsonschema
, magicgui
, napari-console
, napari-npe2
, napari-svg
, numpydoc
, pint
, psutil
, pydantic
, pyopengl
, pillow
, pythonOlder
, pyyaml
, scikitimage
, scipy
, setuptools-scm
, superqt
, tifffile
, toolz
, tqdm
, typing-extensions
, vispy
, wrapQtAppsHook
, wrapt
}:

mkDerivationWith buildPythonPackage rec {
  pname = "napari";
  version = "0.4.16";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Fx3DoTIb2ev5wMP/gmprPIoxeF2f+Cbac6pnWB/zTTw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    appdirs
    cachey
    dask.optional-dependencies.array
    docstring-parser
    imageio
    jsonschema
    magicgui
    napari-console
    napari-npe2
    napari-svg
    numpydoc
    pint
    pillow
    psutil
    pydantic
    pyopengl
    pyyaml
    scikitimage
    scipy
    superqt
    tifffile
    toolz
    tqdm
    typing-extensions
    vispy
    wrapt
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "scikit-image>=0.19.1" "scikit-image" \
      --replace "vispy>=0.10.0,<0.11" "vispy"
  '';

  dontUseSetuptoolsCheck = true;

  postFixup = ''
    wrapQtApp $out/bin/napari
  '';

  meta = with lib; {
    description = "A fast, interactive, multi-dimensional image viewer";
    homepage = "https://github.com/napari/napari";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
