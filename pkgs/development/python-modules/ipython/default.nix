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
# Runtime dependencies
, jedi
, decorator
, pickleshare
, traitlets
, prompt_toolkit
, pexpect
, appnope
, backcall
, fetchpatch
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "7.12.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9459e7237e2e5858738ff9c3e26504b79899b58a6d49e574d352493d80684c6";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  buildInputs = [ glibcLocales ];

  checkInputs = [ nose pygments ];

  propagatedBuildInputs = [
    jedi
    decorator
    pickleshare
    traitlets
    prompt_toolkit
    pygments
    pexpect
    backcall
  ] ++ lib.optionals stdenv.isDarwin [appnope];

  LC_ALL="en_US.UTF-8";

  doCheck = false; # Circular dependency with ipykernel

  checkPhase = ''
    nosetests
  '';

  pythonImportsCheck = [
    "IPython"
  ];

  meta = with lib; {
    description = "IPython: Productive Interactive Computing";
    homepage = http://ipython.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor fridh ];
  };
}
