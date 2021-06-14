{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pkgs
}:

buildPythonPackage rec {
  pname = "python-gnutls";
  version = "3.1.3";

  # https://github.com/AGProjects/python-gnutls/issues/2
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "79f94017e6472ac665c85bc16d68aa2e6681f53b6a9e74516557b49b6fc6a651";
  };

  propagatedBuildInputs = [ pkgs.gnutls ];
  patchPhase = ''
    substituteInPlace gnutls/library/__init__.py --replace "/usr/local/lib" "${pkgs.gnutls.out}/lib"
  '';

  meta = with lib; {
    description = "Python wrapper for the GnuTLS library";
    homepage = "https://github.com/AGProjects/python-gnutls";
    license = licenses.lgpl2;
  };

}
