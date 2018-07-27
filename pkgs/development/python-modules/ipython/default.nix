{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, fetchpatch
# Build dependencies
, glibcLocales
# Test dependencies
, nose
, pygments
# Runtime dependencies
, jedi
, decorator
, pickleshare
, simplegeneric
, traitlets
, prompt_toolkit
, pexpect
, appnope
, typing
, backcall
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "6.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eca537aa61592aca2fef4adea12af8e42f5c335004dfa80c78caf80e8b525e5c";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  # Upgrade to prompt_toolkit 2.0
  patches = fetchpatch {
    url = https://github.com/ipython/ipython/commit/8e256bd37373f98580ba1ef1d3fcfd7976802238.patch;
    sha256 = "1d9qy2z21n4frf15g4aj7xi011d1d3qc31gs27f2v23j0gv69r9h";
  };

  buildInputs = [ glibcLocales ];

  checkInputs = [ nose pygments ];

  propagatedBuildInputs = [
    jedi
    decorator
    pickleshare
    simplegeneric
    traitlets
    prompt_toolkit
    pexpect
    backcall
  ] ++ lib.optionals stdenv.isDarwin [appnope]
    ++ lib.optionals (pythonOlder "3.5") [ typing ];

  LC_ALL="en_US.UTF-8";

  doCheck = false; # Circular dependency with ipykernel

  checkPhase = ''
    nosetests
  '';

  # IPython 6.0.0 and above does not support Python < 3.3.
  # The last IPython version to support older Python versions
  # is 5.3.x.
  disabled = pythonOlder "3.3";

  meta = {
    description = "IPython: Productive Interactive Computing";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bjornfor jgeerds fridh ];
  };
}
