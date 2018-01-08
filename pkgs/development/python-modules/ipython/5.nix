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
  version = "5.5.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "66469e894d1f09d14a1f23b971a410af131daa9ad2a19922082e02e0ddfd150f";
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
