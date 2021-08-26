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
, matplotlib-inline
, pickleshare
, traitlets
, prompt-toolkit
, pexpect
, appnope
, backcall
, fetchpatch
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "7.26.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cff04bb042800129348701f7bd68a430a844e8fb193979c08f6c99f28bb735e";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  buildInputs = [ glibcLocales ];

  checkInputs = [ nose pygments ];

  propagatedBuildInputs = [
    jedi
    decorator
    matplotlib-inline
    pickleshare
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
