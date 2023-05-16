{ lib
, mkDerivationWith
, appdirs
, app-model
, buildPythonPackage
, cachey
, certifi
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
<<<<<<< HEAD
, scikit-image
=======
, scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, scipy
, setuptools-scm
, sphinx
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
<<<<<<< HEAD
  version = "0.4.18";
=======
  version = "0.4.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-xF0DYK+226MZpB050IukNvTg2iHMQAIZW0serKRJd/0=";
=======
    hash = "sha256-34FALCI7h0I295553Rv0KZxKIipuA2OMNsINGde7/oE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "scikit-image>=0.19.1" "scikit-image" \
      --replace "sphinx<5" "sphinx" \
      --replace "vispy>=0.11.0,<0.12" "vispy"
  '';

  nativeBuildInputs = [
    setuptools-scm
    wrapQtAppsHook
  ];

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
    pint
    pillow
    psutil
    pydantic
    pyopengl
    pyyaml
<<<<<<< HEAD
    scikit-image
=======
    scikitimage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    scipy
    sphinx
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
