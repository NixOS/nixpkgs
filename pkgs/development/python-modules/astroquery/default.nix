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
}:

buildPythonPackage rec {
  pname = "astroquery";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zw3xp2rfc6h2v569iqsyvzhfnzp7bfjb7jrj61is1hrqw1cqjrb";
  };

  # Fix tests using conftest.py from HEAD in the upstream GitHub
  # repository.
  patches = [ ./conftest-astropy-3-fix.patch ];

  propagatedBuildInputs = [ astropy requests keyring beautifulsoup4 html5lib ];

  nativeBuildInputs = [ astropy-helpers ];

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
