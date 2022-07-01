{ pkgs
, buildPythonPackage
, fetchPypi
, astropy
, requests
, keyring
, beautifulsoup4
, html5lib
, matplotlib
, pillow
, pytest
, pytest-astropy
, pytestCheckHook
, pyvo
, astropy-helpers
, isPy3k
}:

buildPythonPackage rec {
  pname = "astroquery";
  version = "0.4.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MHylVMtzSgypoi+G9e/+fkE6+ROuZeFXiXLYR7H+E+4=";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [
    astropy
    requests
    keyring
    beautifulsoup4
    html5lib
    pyvo
  ];

  nativeBuildInputs = [ astropy-helpers ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  checkInputs = [
    matplotlib
    pillow
    pytest
    pytest-astropy
    pytestCheckHook
  ];

  # Tests must be run in the build directory. The tests create files
  # in $HOME/.astropy so we need to set HOME to $TMPDIR.
  preCheck = ''
    export HOME=$TMPDIR
    cd build/lib
  '';

  pythonImportsCheck = [ "astroquery" ];

  meta = with pkgs.lib; {
    description = "Functions and classes to access online data resources";
    homepage = "https://astroquery.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.smaret ];
  };
}
