{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, pkgs
}:

buildPythonPackage rec {
  pname = "python-gnutls";
  version = "3.1.2";

  # https://github.com/AGProjects/python-gnutls/issues/2
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "28748e02a8035c31826152944e41217ebcc58ab7793ae5a22850cd23d3cfbbbe";
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
