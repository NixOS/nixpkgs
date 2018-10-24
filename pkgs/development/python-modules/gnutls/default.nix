{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, pkgs
}:

buildPythonPackage rec {
  pname = "python-gnutls";
  version = "3.1.1";

  # https://github.com/AGProjects/python-gnutls/issues/2
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ncsz72i6vrhvxpd90y9k74qdfw3pfcj39pvn5dxp6m834ani4l8";
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
