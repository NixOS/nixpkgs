{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, pkgs
}:

buildPythonPackage rec {
  pname = "python-gnutls";
  version = "3.0.0";

  # https://github.com/AGProjects/python-gnutls/issues/2
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yrdxcj5rzvz8iglircz6icvyggz5fmdcd010n6w3j60yp4p84kc";
  };

  propagatedBuildInputs = [ pkgs.gnutls ];
  patchPhase = ''
    substituteInPlace gnutls/library/__init__.py --replace "/usr/local/lib" "${pkgs.gnutls.out}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Python wrapper for the GnuTLS library";
    homepage = https://github.com/AGProjects/python-gnutls;
    license = licenses.lgpl2;
  };

}
