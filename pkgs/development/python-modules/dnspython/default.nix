{
  lib,
  aioquic,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  h2,
  httpcore,
  httpx,
  idna,
  hatchling,
  pytestCheckHook,
  trio,
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GB08aZZFLLEYnEBGxhWZuEpahuCZVi/9530mmE/ybQ8=";
  };

  build-system = [ hatchling ];

  optional-dependencies = {
    doh = [
      httpx
      h2
      httpcore
    ];
    idna = [ idna ];
    dnssec = [ cryptography ];
    trio = [ trio ];
    doq = [ aioquic ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # dns.exception.SyntaxError: protocol not found
    "test_misc_good_WKS_text"
  ];

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
