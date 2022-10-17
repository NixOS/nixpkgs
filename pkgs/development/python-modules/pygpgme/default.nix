{ lib, buildPythonPackage, fetchurl, isPyPy
, gpgme }:

buildPythonPackage rec {
  version = "0.3";
  pname = "pygpgme";
  disabled = isPyPy;

  src = fetchurl {
    url = "https://launchpad.net/pygpgme/trunk/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "5fd887c407015296a8fd3f4b867fe0fcca3179de97ccde90449853a3dfb802e1";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ gpgme ];

  meta = with lib; {
    homepage = "https://launchpad.net/pygpgme";
    description = "A Python wrapper for the GPGME library";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };
}
