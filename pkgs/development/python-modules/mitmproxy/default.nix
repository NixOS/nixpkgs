{ stdenv
, fetchFromGitHub
, buildPythonPackage
, isPy27
, fetchpatch
# Mitmproxy requirements
, blinker
, brotli
, certifi
, click
, cryptography
, flask
, h2
, hyperframe
, kaitaistruct
, ldap3
, passlib
, protobuf
, pyasn1
, pyopenssl
, pyparsing
, pyperclip
, ruamel_yaml
, setuptools
, sortedcontainers
, tornado
, urwid
, wsproto
, publicsuffix2
, zstandard
# Additional check requirements
, beautifulsoup4
, glibcLocales
, pytest
, requests
, asynctest
, parver
, pytest-asyncio
, hypothesis
}:

buildPythonPackage rec {
  pname = "mitmproxy";
  version = "5.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0ja0aqnfmkvns5qmd51hmrvbw8dnccaks30gxgzgcjgy30rj4brq";
  };

  patches = [
    # Apply patch from upstream to make mitmproxy v5.2 compatible with urwid >v2.1.0
    (fetchpatch {
      name = "urwid-lt-2.1.0.patch";
      url = "https://github.com/mitmproxy/mitmproxy/commit/ea9177217208fdf642ffc54f6b1f6507a199350c.patch";
      sha256 = "1z5r8izg5nvay01ywl3xc6in1vjfi9f144j057p3k5rzfliv49gg";
    })
  ];

  postPatch = ''
    # remove dependency constraints
    sed 's/>=\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?//' -i setup.py
  '';

  doCheck = (!stdenv.isDarwin);

  checkPhase = ''
    export HOME=$(mktemp -d)
    pytest -k 'not test_get_version' # expects a Git repository
  '';

  propagatedBuildInputs = [
    setuptools
    # setup.py
    blinker
    brotli
    certifi
    click
    cryptography
    flask
    h2
    hyperframe
    kaitaistruct
    ldap3
    passlib
    protobuf
    publicsuffix2
    pyasn1
    pyopenssl
    pyparsing
    pyperclip
    ruamel_yaml
    sortedcontainers
    tornado
    urwid
    wsproto
    zstandard
  ];

  checkInputs = [
    asynctest
    beautifulsoup4
    flask
    glibcLocales
    hypothesis
    parver
    pytest
    pytest-asyncio
    requests
  ];

  meta = with stdenv.lib; {
    description = "Man-in-the-middle proxy";
    homepage    = "https://mitmproxy.org/";
    license     = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
