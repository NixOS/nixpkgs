{
  lib,
  stdenv,
  libdiscid,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "discid";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-cWChIRrD1qbYIT+4jdPXPjKr5eATNqWkyYWwgql9QzU=";
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

  meta = with lib; {
    description = "Python binding of libdiscid";
    homepage = "https://python-discid.readthedocs.org/";
    license = licenses.lgpl3Plus;
  };
}
