{ lib
, mkDerivationWith
, buildPythonPackage
, fetchFromGitHub
, setuptools-scm
, superqt
, typing-extensions
, tifffile
, napari-plugin-engine
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
  version = "0.4.14";
  src = fetchFromGitHub {
    owner = "napari";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uDDj5dzsT4tRVV0Y+CYegiCpLM77XFaXEXEZXTnX808=";
  };
  nativeBuildInputs = [ setuptools-scm wrapQtAppsHook ];
  propagatedBuildInputs = [
    napari-plugin-engine
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
  SETUPTOOLS_SCM_PRETEND_VERSION = version;
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
