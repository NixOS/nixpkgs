{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "fusepy";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gg69qfi9pjcic3g98l8ya64rw2vc1bp8gsf76my6gglq8z7izvj";
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
    homepage = "https://github.com/terencehonles/fusepy";
    license = licenses.isc;
    platforms = platforms.unix;
  };

}
