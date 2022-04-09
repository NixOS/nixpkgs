{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pkg-config
, openssl
, publicsuffix-list
, pythonOlder
, libiconv
, CoreFoundation
, Security
, pytestCheckHook
, toml
}:

buildPythonPackage rec {
  pname = "adblock";
  version = "0.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  # Pypi only has binary releases
  src = fetchFromGitHub {
    owner = "ArniDagur";
    repo = "python-adblock";
    rev = "refs/tags/${version}";
    sha256 = "sha256-6FH+AVK7+Yg1a6oKbFV80TuGGE4Y7I3mMVzwVHdHYO4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-JI/C+Woi/dJWUGUum8daecjFWiQgxY6BFYZ5MpTcRvU=";
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    CoreFoundation
    Security
  ];

  PSL_PATH = "${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat";

  checkInputs = [
    pytestCheckHook
    toml
  ];

  preCheck = ''
    # import from $out instead
    rm -r adblock
  '';

  disabledTestPaths = [
    # relies on directory removed above
    "tests/test_typestubs.py"
  ];

  pythonImportsCheck = [
    "adblock"
    "adblock.adblock"
  ];

  meta = with lib; {
    description = "Python wrapper for Brave's adblocking library";
    homepage = "https://github.com/ArniDagur/python-adblock/";
    maintainers = with maintainers; [ petabyteboy dotlambda ];
    license = with licenses; [ asl20 /* or */ mit ];
  };
}
