{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "yex-lang";
  version = "unstable-2021-12-25";

  src = fetchFromGitHub {
    owner = "nonamescm";
    repo = "yex-lang";
    rev = "a97def1431b73b8693700f530ec023f1776eaf83";
    hash = "sha256-CEzJtlEVMvMnRyUKdko1UDTluv8Fc88tfOpKGIFMnRw=";
  };

  cargoSha256 = "sha256-mHMenqcdt9Yjm/6H1Ywf637Sv8ddq6a4Eu2/A/jX9gQ=";

  meta = with lib; {
    homepage = "https://github.com/nonamesc/yex-lang";
    description = "A cool functional scripting language written in rust";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isAarch64 && stdenv.isLinux;
  };
}
