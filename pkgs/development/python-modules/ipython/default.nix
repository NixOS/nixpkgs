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
  version = "7.10.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03h3m64k8jq0cc48i34g8xq0r68cx3w7wz721mfhr7k06qdv11pi";
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
