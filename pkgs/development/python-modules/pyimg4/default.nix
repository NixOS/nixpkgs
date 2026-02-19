{
  apple-compress,
  asn1,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  lib,
  lzfse,
  pycryptodome,
  pylzss,
  pytestCheckHook,
  remotezip,
  stdenv,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pyimg4";
  version = "0.8.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m1stadev";
    repo = "PyIMG4";
    tag = "v${version}";
    hash = "sha256-rGFHd4MAJrbKhtX+Ey/zqQ/12wWxDyBBy1xPGDFQjao=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  pythonRelaxDeps = [
    "pylzss"
  ];

  dependencies = [
    asn1
    click
    pycryptodome
    pylzss
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    apple-compress
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    lzfse
  ];

  pythonImportsCheck = [ "pyimg4" ];

  nativeCheckInputs = [
    pytestCheckHook
    remotezip
  ];

  disabledTests = [
    # tests take forever
    "test_read_lzss_dec"
    "test_read_lzss_enc"
    "test_read_lzfse_dec"
    "test_read_lzfse_enc"
    "test_read_payp"
  ];

  meta = {
    changelog = "https://github.com/m1stadev/PyIMG4/releases/tag/${src.tag}";
    description = "Python library/CLI tool for parsing Apple's Image4 format";
    homepage = "https://github.com/m1stadev/PyIMG4";
    license = lib.licenses.mit;
    mainProgram = "pyimg4";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
