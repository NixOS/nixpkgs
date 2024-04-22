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
, scikit-image
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
  version = "0.4.19.post1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qw5WdFPySNkmm+dNu+hqsmr+csBpHnSl9bMpb4nKEqI=";
  };

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
    scikit-image
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
