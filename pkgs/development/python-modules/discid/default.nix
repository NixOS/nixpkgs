{ stdenv, libdiscid, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "discid";
  version = "1.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b39d443051b26d0230be7a6c616243daae93337a8711dd5d4119bb6a0e516fa8";
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
