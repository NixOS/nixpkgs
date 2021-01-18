{ lib, stdenv
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
, asgiref
, msgpack
}:

buildPythonPackage rec {
  pname = "mitmproxy";
  version = "5.3.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "04y7fxxssrs14i7zl7fwlwrpnms39i7a6m18481sg8vlrkbagxjr";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/>=\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?\( \?, \?!=\([0-9]\.\?\)\+\)\?//' -i setup.py
  '';

  doCheck = (!stdenv.isDarwin);

  checkPhase = ''
    export HOME=$(mktemp -d)
    pytest -k 'not test_get_version' # expects a Git repository
  '';

  propagatedBuildInputs = [
    setuptools
    # setup.py
    asgiref
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
    msgpack
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

  meta = with lib; {
    description = "Man-in-the-middle proxy";
    homepage    = "https://mitmproxy.org/";
    license     = licenses.mit;
    maintainers = with maintainers; [ fpletz kamilchm ];
  };
}
