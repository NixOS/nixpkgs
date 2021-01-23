{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pipInstallHook
, pythonImportsCheckHook
, maturin
, pkg-config
, openssl
, publicsuffix-list
, isPy27
, CoreFoundation
, Security
}:

rustPlatform.buildRustPackage rec {
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
  format = "pyproject";

  cargoSha256 = "0di05j942rrm2crpdpp9czhh65fmidyrvdp2n3pipgnagy7nchc0";

  nativeBuildInputs = [ pipInstallHook maturin pkg-config pythonImportsCheckHook ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security ];

  PSL_PATH = "${publicsuffix-list}/share/publicsuffix/public_suffix_list.dat";

  buildPhase = ''
    runHook preBuild
    maturin build --release --manylinux off --strip
    runHook postBuild
  '';

  # There are no rust tests
  doCheck = false;
  pythonImportsCheck = [ "adblock" ];

  installPhase = ''
    runHook preInstall
    install -Dm644 -t dist target/wheels/*.whl
    pipInstallPhase
    runHook postInstall
  '';

  passthru.meta = with lib; {
    description = "Python wrapper for Brave's adblocking library, which is written in Rust";
    homepage = "https://github.com/ArniDagur/python-adblock/";
    maintainers = with maintainers; [ petabyteboy ];
    license = with licenses; [ asl20 mit ];
    platforms = with platforms; [ all ];
  };
}
