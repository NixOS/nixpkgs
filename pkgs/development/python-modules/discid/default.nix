{ lib, stdenv, libdiscid, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "discid";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fc6kvnqwaz9lrs2qgsp8wh0nabf49010r0r53wnsmpmafy315nd";
  };

  patchPhase =
    let extension = stdenv.hostPlatform.extensions.sharedLibrary; in
    ''
      substituteInPlace discid/libdiscid.py \
        --replace "_open_library(_LIB_NAME)" \
                  "_open_library('${libdiscid}/lib/libdiscid${extension}')"
    '';

  meta = with lib; {
    description = "Python binding of libdiscid";
    homepage    = "https://python-discid.readthedocs.org/";
    license     = licenses.lgpl3Plus;
  };
}
