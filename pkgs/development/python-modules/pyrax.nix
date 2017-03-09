{ lib, buildPythonPackage, fetchurl, requests2, novaclient, keyring,
  rackspace-novaclient, six, isPy3k, pytest, glibcLocales }:
buildPythonPackage rec {
  name = "pyrax-1.9.8";

  src = fetchurl {
    url = "mirror://pypi/p/pyrax/${name}.tar.gz";
    sha256 = "1x98jzyxnvha81pgx3jpfixljhs7zik89yfp8q06kwpx8ws99nz9";
  };

  # no good reason given in commit why limited, and seems to work
  patchPhase = ''
      substituteInPlace "setup.py"                                     \
              --replace "python-novaclient==2.27.0" "python-novaclient"
    '';

  disabled = isPy3k;
  propagatedBuildInputs = [ requests2 novaclient keyring rackspace-novaclient six ];

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ pytest glibcLocales ];

  checkPhase = ''
    py.test tests/unit
  '';

  meta = {
    homepage = "https://github.com/rackspace/pyrax";
    license = lib.licenses.asl20;
    description = "Python API to interface with Rackspace";
    maintainers = with lib.maintainers; [ teh ];
  };
}
