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
  version = "1.59.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = version;
    sha256 = "1lwck5gb2kys7wxg08q3pnb8cqhzwwqy6nxcf2yc030gmnwm4sya";
  };

  patches = [
    # https://github.com/deltachat/deltachat-core-rust/pull/2589
    (fetchpatch {
      url = "https://github.com/deltachat/deltachat-core-rust/commit/408467e85d04fbbfd6bed5908d84d9e995943487.patch";
      sha256 = "1j2ywaazglgl6370js34acrg0wrh0b7krqg05dfjf65n527lzn59";
    })
    ./no-static-lib.patch
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "13zzc8c50cy6fknrxzw5gf6rcclsn5bcb2bi3z9mmzsl29ga32gx";
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
