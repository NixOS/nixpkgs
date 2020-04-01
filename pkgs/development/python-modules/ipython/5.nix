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

  patches = [
    # Use the proper pygments lexer for python2 (https://github.com/ipython/ipython/pull/12095)
    (fetchpatch {
      name = "python2-lexer.patch";
      url = "https://github.com/ipython/ipython/pull/12095/commits/8805293b5e4bce9150cc2ad9c5d6d984849ae447.patch";
      sha256 = "16p4gl7a49v76w33j39ih7yspy6x2d14p9bh4wdpg9cafhw9nbc0";
    })
  ];

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
    maintainers = with lib.maintainers; [ bjornfor orivej lnl7 ];
  };
}
