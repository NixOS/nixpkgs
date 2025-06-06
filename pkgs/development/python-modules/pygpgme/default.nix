{
  lib,
  buildPythonPackage,
  fetchurl,
  gpgme,
  isPyPy,
  pythonAtLeast,
}:

buildPythonPackage rec {
  version = "0.3";
  format = "setuptools";
  pname = "pygpgme";

  # Native code doesn't compile against the C API of Python 3.11:
  # https://bugs.launchpad.net/pygpgme/+bug/1996122
  disabled = isPyPy || pythonAtLeast "3.11";

  src = fetchurl {
    url = "https://launchpad.net/pygpgme/trunk/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "5fd887c407015296a8fd3f4b867fe0fcca3179de97ccde90449853a3dfb802e1";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ gpgme ];

  meta = with lib; {
    homepage = "https://launchpad.net/pygpgme";
    description = "Python wrapper for the GPGME library";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };
}
