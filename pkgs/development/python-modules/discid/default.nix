{
  lib,
  stdenv,
  libdiscid,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinxHook,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "discid";
  version = "1.4.0";
  pyproject = true;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UP09tEXK60S593Y3d+1JaIw89GM9qZ00DCW5GUlrqLU=";
  };

  build-system = [
    setuptools
  ];

  patchPhase =
    let
      extension = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      substituteInPlace discid/libdiscid.py \
        --replace "_open_library(_LIB_NAME)" \
                  "_open_library('${libdiscid}/lib/libdiscid${extension}')"
    '';

  nativeBuildInputs = [
    sphinxHook
    sphinx-autodoc-typehints
    sphinx-rtd-theme
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python binding of libdiscid";
    homepage = "https://python-discid.readthedocs.org/";
    license = lib.licenses.lgpl3Plus;
  };
}
