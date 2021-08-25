{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pkg-config
, openssl
, publicsuffix-list
, isPy27
, libiconv
, CoreFoundation
, Security
, pytestCheckHook
, toml
}:

buildPythonPackage rec {
  pname = "adblock";
  version = "0.5.0";
  disabled = isPy27;

  # Pypi only has binary releases
  src = fetchFromGitHub {
    owner = "ArniDagur";
    repo = "python-adblock";
    rev = version;
    sha256 = "sha256-JjmMfL24778T6LCuElXsD7cJxQ+RkqbNEnEqwoN24WE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-w+/W4T3ukRHNpCPjhlHZLPn6sgCpz4QHVD8VW+Rw5BI=";
  };

  format = "pyproject";

  nativeBuildInputs = [ pkg-config ]
    ++ (with rustPlatform; [ cargoSetupHook maturinBuildHook ]);

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv CoreFoundation Security ];

  PSL_PATH = "${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat";

  checkInputs = [ pytestCheckHook toml ];

  preCheck = ''
    # import from $out instead
    rm -r adblock
  '';

  disabledTestPaths = [
    # relies on directory removed above
    "tests/test_typestubs.py"
  ];

  pythonImportsCheck = [ "adblock" "adblock.adblock" ];

  meta = with lib; {
    description = "Python wrapper for Brave's adblocking library, which is written in Rust";
    homepage = "https://github.com/ArniDagur/python-adblock/";
    maintainers = with maintainers; [ petabyteboy dotlambda ];
    license = with licenses; [ asl20 mit ];
  };
}
