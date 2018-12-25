{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
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
  version = "5.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bac649857611baaaf76bc82c173aa542f7486446c335fe1a6c05d0d491c8906";
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
