{ stdenv, libdiscid, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "discid";
  version = "1.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78a3bf6c8377fdbe3d85e914a209ff97aa43e35605779639847b510ced31f7b9";
  };

  patchPhase = ''
    substituteInPlace discid/libdiscid.py \
      --replace '_open_library(_LIB_NAME)' "_open_library('${libdiscid}/lib/libdiscid.so.0')"
  '';

  meta = with stdenv.lib; {
    description = "Python binding of libdiscid";
    homepage    = "https://python-discid.readthedocs.org/";
    license     = licenses.lgpl3Plus;
    platforms   = platforms.linux;
  };
}
