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
  version = "7.5.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e840810029224b56cd0d9e7719dc3b39cf84d577f8ac686547c8ba7a06eeab26";
  };

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  patches = [
    (fetchpatch {
      url = "https://github.com/ipython/ipython/commit/e1b53e9ef91a43b9e275bb9e48b4253218375d87.patch";
      sha256 = "sha256:0q7zsgalwxss6aikhakbdkvvz0g4ac4sa3ncrklm74ksqh56rsgb";
    })
  ];

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

  meta = {
    description = "IPython: Productive Interactive Computing";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bjornfor fridh ];
  };
}
