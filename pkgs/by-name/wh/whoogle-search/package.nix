{
  lib,
  python3Packages,
  fetchPypi,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "whoogle-search";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "whoogle_search";
    inherit version;
    hash = "sha256-JpTvt7A81gisijWaXu0Rh/vPwjA95hvmpzRBwjvByiI=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    attrs
    beautifulsoup4
    brotli
    cachelib
    certifi
    cffi
    chardet
    click
    cryptography
    cssutils
    defusedxml
    flask
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
    pysocks
    python-dateutil
    requests
    soupsieve
    stem
    urllib3
    validators
    waitress
    wcwidth
    werkzeug
    python-dotenv
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
    description = "A self-hosted, ad-free, privacy-respecting metasearch engine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malte-v ];
    mainProgram = "whoogle-search";
  };
}
