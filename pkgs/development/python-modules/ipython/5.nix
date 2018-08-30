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
  version = "5.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g1jm06qriq48m58311cs7askp83ipq3yq96hv4kg431nxzkmd4d";
  };

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  patches = [
    # improve cython support, needed by sage, accepted upstream
    # https://github.com/ipython/ipython/pull/11139
    (fetchpatch {
      name = "signature-use-inspect.patch";
      url = "https://github.com/ipython/ipython/commit/8d399b98d3ed5c765835594100c4d36fb2f739dc.patch";
      sha256 = "1r7v9clwwbskmj4y160vcj6g0vzqbvnj4y1bm2n4bskafapm42g0";
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
    maintainers = with lib.maintainers; [ bjornfor jgeerds orivej lnl7 ];
  };
}
