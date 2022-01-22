{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
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
, pytest
}:

buildPythonPackage rec {
  pname = "ipython";
  version = "7.28.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2097be5c814d1b974aea57673176a924c4c8c9583890e7a5f082f547b9975b11";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-21699.patch";
      url = "https://github.com/ipython/ipython/commit/67ca2b3aa9039438e6f80e3fccca556f26100b4d.patch";
      excludes = [ "docs/source/whatsnew/version7.rst" ];
      sha256 = "1ybpgfqppkzaz4q15qgacvhicdxfsdacl89sgj2fd9llc5mvfl26";
    })
  ];

  prePatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace setup.py --replace "'gnureadline'" " "
  '';

  buildInputs = [ glibcLocales ];


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

  # full tests normally disabled due to a circular dependency with
  # ipykernel, but we want to test the CVE-2022-21699 fix in this
  # branch
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest IPython/tests/cve.py
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
