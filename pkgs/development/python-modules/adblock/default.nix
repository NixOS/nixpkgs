{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonImportsCheckHook
, pkg-config
, openssl
, publicsuffix-list
, isPy27
, CoreFoundation
, Security
}:

buildPythonPackage rec {
  pname = "adblock";
  version = "0.4.0";
  disabled = isPy27;

  # Pypi only has binary releases
  src = fetchFromGitHub {
    owner = "ArniDagur";
    repo = "python-adblock";
    rev = version;
    sha256 = "10d6ks2fyzbizq3kb69q478idj0h86k6ygjb6wl3zq3mf65ma4zg";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-gEFmj3/KvhvvsOK2nX2L1RUD4Wfp3nYzEzVnQZIsIDY=";
  };

  format = "pyproject";

  nativeBuildInputs = [ pkg-config pythonImportsCheckHook ]
    ++ (with rustPlatform; [ cargoSetupHook maturinBuildHook ]);

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security ];

  PSL_PATH = "${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat";

  # There are no rust tests
  doCheck = false;

  pythonImportsCheck = [ "adblock" ];

  meta = with lib; {
    description = "Python wrapper for Brave's adblocking library, which is written in Rust";
    homepage = "https://github.com/ArniDagur/python-adblock/";
    maintainers = with maintainers; [ petabyteboy ];
    license = with licenses; [ asl20 mit ];
  };
}
