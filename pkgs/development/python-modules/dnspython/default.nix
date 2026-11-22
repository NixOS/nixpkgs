{
  lib,
  aioquic,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  h2,
  httpcore,
  httpx2,
  idna,
  uv-build,
  pytestCheckHook,
  trio,
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tE3GsY8HqLHFZnahn7/bUglBWwRqnOzihrqvqH/z9/E=";
  };

  build-system = [ uv-build ];

  optional-dependencies = {
    doh = [
      httpx2
      h2
      httpcore
    ];
    idna = [ idna ];
    dnssec = [ cryptography ];
    trio = [ trio ];
    doq = [ aioquic ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    idna
  ];

  disabledTests = [
    # dns.exception.SyntaxError: protocol not found
    "test_misc_good_WKS_text"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.9.21,<0.13.0' "uv_build"
  '';

  # disable network on all builds (including darwin)
  # see https://github.com/NixOS/nixpkgs/issues/356803
  preCheck = ''
    export NO_INTERNET=1
  '';

  pythonImportsCheck = [ "dns" ];

  meta = {
    description = "DNS toolkit for Python";
    homepage = "https://www.dnspython.org";
    changelog = "https://github.com/rthalley/dnspython/blob/v${version}/doc/whatsnew.rst";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ gador ];
  };
}
