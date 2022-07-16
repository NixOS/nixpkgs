{ lib
, mkDerivationWith
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, superqt
, typing-extensions
, tifffile
, napari-npe2
, pint
, pyyaml
, numpydoc
, dask
, magicgui
, docstring-parser
, appdirs
, imageio
, pyopengl
, cachey
, napari-svg
, psutil
, napari-console
, wrapt
, pydantic
, tqdm
, jsonschema
, scipy
, wrapQtAppsHook
}: mkDerivationWith buildPythonPackage rec {
  pname = "napari";
  version = "0.4.16";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Fx3DoTIb2ev5wMP/gmprPIoxeF2f+Cbac6pnWB/zTTw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
    wrapQtAppsHook
  ];
  propagatedBuildInputs = [
    napari-npe2
    cachey
    napari-svg
    napari-console
    superqt
    magicgui
    typing-extensions
    tifffile
    pint
    pyyaml
    numpydoc
    dask
    docstring-parser
    appdirs
    imageio
    pyopengl
    psutil
    wrapt
    pydantic
    tqdm
    jsonschema
    scipy
  ];

  dontUseSetuptoolsCheck = true;
  postFixup = ''
    wrapQtApp $out/bin/napari
  '';

  meta = with lib; {
    description = "A fast, interactive, multi-dimensional image viewer for python";
    homepage = "https://github.com/napari/napari";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
