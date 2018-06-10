{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
# Build dependencies
, glibcLocales
# Test dependencies
, nose
, pygments
, testpath
, isPy27
, mock
# Runtime dependencies
, backports_shutil_get_terminal_size
, jedi
, decorator
, pathlib2
, pickleshare
, requests
, simplegeneric
, traitlets
, prompt_toolkit
, pexpect
, appnope
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "5.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g1jm06qriq48m58311cs7askp83ipq3yq96hv4kg431nxzkmd4d";
  };

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  buildInputs = [ glibcLocales ];

  checkInputs = [ nose pygments testpath ] ++ lib.optional isPy27 mock;

  propagatedBuildInputs = [
    backports_shutil_get_terminal_size decorator pickleshare prompt_toolkit
    simplegeneric traitlets requests pathlib2 pexpect
  ] ++ lib.optionals stdenv.isDarwin [ appnope ];

  LC_ALL="en_US.UTF-8";

  doCheck = false; # Circular dependency with ipykernel

  checkPhase = ''
    nosetests
  '';

  meta = {
    description = "IPython: Productive Interactive Computing";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bjornfor jgeerds orivej lnl7 ];
  };
}
