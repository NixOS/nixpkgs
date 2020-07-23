{ stdenv
, fetchFromGitHub
, buildPythonPackage
, isPy27
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
  version = "5.1.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1lirlckpvd3c6s6q3p32w4k4yfna5mlgr1x9g39lhzzq0sdiz3lk";
  };

  postPatch = ''
    # remove dependency constraints
    sed 's/>=\([0-9]\.\?\)\+\( \?, \?<\([0-9]\.\?\)\+\)\?//' -i setup.py
  '';

  doCheck = (!stdenv.isDarwin);

  # examples.complex.xss_scanner doesn't import correctly with pytest5
  checkPhase = ''
    export HOME=$(mktemp -d)
    export LC_CTYPE=en_US.UTF-8
    pytest --ignore test/examples \
      -k 'not test_find_unclaimed_URLs and not test_tcp'
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
