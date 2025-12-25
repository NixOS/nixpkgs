{
  lib,
  python3Packages,
  fetchPypi,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "whoogle-search";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "whoogle_search";
    inherit version;
    hash = "sha256-1oPpCn9qeg/N/BA8Hv3+x4d7A5qEgcSI8i8B5XALQdw=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    attrs
    beautifulsoup4
    brotli
    cachetools
    certifi
    cffi
    click
    cryptography
    cssutils
    defusedxml
    flask
    h11
    httpcore
    httpx
    httpx.optional-dependencies.http2
    httpx.optional-dependencies.socks
    idna
    itsdangerous
    jinja2
    markupsafe
    more-itertools
    packaging
    pluggy
    pycodestyle
    pycparser
    pyopenssl
    pyparsing
    pytest
    python-dateutil
    python-dotenv
    soupsieve
    stem
    validators
    waitress
    wcwidth
    werkzeug
  ];

  postInstall = ''
    # This creates renamed versions of the static files for cache busting,
    # without which whoogle will not run. If we don't do this here, whoogle
    # will attempt to create them on startup, which fails since the nix store
    # is read-only.
    python3 $out/${python3Packages.python.sitePackages}/app/__init__.py
  '';

  passthru.tests = {
    inherit (nixosTests) whoogle-search;
  };

  meta = {
    homepage = "https://github.com/benbusby/whoogle-search";
    description = "Self-hosted, ad-free, privacy-respecting metasearch engine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malte-v ];
    mainProgram = "whoogle-search";
  };
}
