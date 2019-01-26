{ stdenv, libdiscid, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "discid";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78a3bf6c8377fdbe3d85e914a209ff97aa43e35605779639847b510ced31f7b9";
  };

  patchPhase =
    let extension = stdenv.hostPlatform.extensions.sharedLibrary; in
    ''
      substituteInPlace discid/libdiscid.py \
        --replace "_open_library(_LIB_NAME)" \
                  "_open_library('${libdiscid}/lib/libdiscid${extension}')"
    '';

  meta = with stdenv.lib; {
    description = "Python binding of libdiscid";
    homepage    = "https://python-discid.readthedocs.org/";
    license     = licenses.lgpl3Plus;
  };
}
