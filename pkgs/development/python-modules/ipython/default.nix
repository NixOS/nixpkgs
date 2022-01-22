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
, black
, jedi
, decorator
, matplotlib-inline
, pickleshare
, traitlets
, prompt-toolkit
, pexpect
, appnope
, backcall
, stack-data
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "8.0.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x19sj4dlq7r4p1mqnpx9245r8dwvpjwd8n34snfm37a452lsmmb";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  buildInputs = [ glibcLocales ];

  checkInputs = [ nose pygments ];

  propagatedBuildInputs = [
    black
    jedi
    decorator
    matplotlib-inline
    pickleshare
    stack-data
    traitlets
    prompt-toolkit
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
    homepage = "http://ipython.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bjornfor fridh ];
  };
}
