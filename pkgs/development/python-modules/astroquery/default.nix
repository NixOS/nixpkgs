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
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ce57a8792c7d5d74206d797d379de6da35d56be433ea5840c41a49f202e2fab";
  };

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
