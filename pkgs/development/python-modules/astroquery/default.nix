{ pkgs
, buildPythonPackage
, fetchPypi
, astropy
, requests
, keyring
, beautifulsoup4
, html5lib
, pytest
, pytest-astropy
, astropy-helpers
, isPy3k
}:

buildPythonPackage rec {
  pname = "astroquery";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xpqrl9h7sg55mql38xsfpbz9rxsm3mxfha1biqyly1gmxpmd47a";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ astropy requests keyring beautifulsoup4 html5lib ];

  nativeBuildInputs = [ astropy-helpers ];

  # Tests disabled until pytest-astropy has been updated to include pytest-astropy-header
  doCheck = false;
  checkInputs = [ pytest pytest-astropy ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  # Tests must be run in the build directory. The tests create files
  # in $HOME/.astropy so we need to set HOME to $TMPDIR.
  checkPhase = ''
    cd build/lib
    HOME=$TMPDIR pytest
  '';

  meta = with pkgs.lib; {
    description = "Functions and classes to access online data resources";
    homepage = "https://astroquery.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
