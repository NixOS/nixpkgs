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
  version = "2.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mm0w5V+Nxj5gUll2ZhEr/wWGuVokdKne2gOvu/gg03o=";
  };


  postPatch = ''
    sed -Ei 's/(uv_build)[<>=!~][^"]*/\1/' pyproject.toml
  '';

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
