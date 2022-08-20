{ lib, buildPythonPackage, fetchPypi, gnupg }:

buildPythonPackage rec {
  pname = "python-gnupg";
  version = "0.4.9";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qqdIeVVyWRqvEntKyJhWhPNnP/grOfNwyDawBuaPxTc=";
  };

  postPatch = ''
    substituteInPlace gnupg.py \
      --replace "gpgbinary='gpg'" "gpgbinary='${gnupg}/bin/gpg'"
    substituteInPlace test_gnupg.py \
      --replace "os.environ.get('GPGBINARY', 'gpg')" "os.environ.get('GPGBINARY', '${gnupg}/bin/gpg')"
  '';

  pythonImportsCheck = [ "gnupg" ];

  meta = with lib; {
    description = "API for the GNU Privacy Guard (GnuPG)";
    homepage = "https://github.com/vsajip/python-gnupg";
    license = licenses.bsd3;
    maintainers = with maintainers; [ copumpkin ];
  };
}
