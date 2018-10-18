{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "fusepy";
  version = "2.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v5grm4zyf58hsplwsxfbihddw95lz9w8cy3rpzbyha287swgx8h";
  };

  propagatedBuildInputs = [ pkgs.fuse ];

  # No tests included
  doCheck = false;

  patchPhase = ''
    substituteInPlace fuse.py --replace \
      "find_library('fuse')" "'${pkgs.fuse}/lib/libfuse.so'"
  '';

  meta = with stdenv.lib; {
    description = "Simple ctypes bindings for FUSE";
    longDescription = ''
      Python module that provides a simple interface to FUSE and MacFUSE.
      It's just one file and is implemented using ctypes.
    '';
    homepage = https://github.com/terencehonles/fusepy;
    license = licenses.isc;
    platforms = platforms.unix;
  };

}
