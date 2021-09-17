{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, openssl
, perl
, pkg-config
, rustPlatform
, sqlite
, fixDarwinDylibNames
, CoreFoundation
, Security
, libiconv
}:

stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.60.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = version;
    sha256 = "1agm5xyaib4ynmw4mhgmkhh4lnxs91wv0q9i1zfihv2vkckfm2s2";
  };

  patches = [
    # https://github.com/deltachat/deltachat-core-rust/pull/2589
    (fetchpatch {
      url = "https://github.com/deltachat/deltachat-core-rust/commit/408467e85d04fbbfd6bed5908d84d9e995943487.patch";
      sha256 = "1j2ywaazglgl6370js34acrg0wrh0b7krqg05dfjf65n527lzn59";
    })
    ./no-static-lib.patch
    # https://github.com/deltachat/deltachat-core-rust/pull/2660
    (fetchpatch {
      url = "https://github.com/deltachat/deltachat-core-rust/commit/8fb5e038a97d8ae68564c885d61b93127a68366d.patch";
      sha256 = "088pzfrrkgfi4646dc72404s3kykcpni7hgkppalwlzg0p4is41x";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "09d3mw2hb1gmqg7smaqwnfm7izw40znl0h1dz7s2imms2cnkjws1";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
  ]) ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    openssl
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    CoreFoundation
    Security
    libiconv
  ];

  checkInputs = with rustPlatform; [
    cargoCheckHook
  ];

  meta = with lib; {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/";
    changelog = "https://github.com/deltachat/deltachat-core-rust/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
