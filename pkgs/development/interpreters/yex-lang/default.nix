{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "yex-lang";
  version = "unstable-2021-12-25";

  src = fetchFromGitHub {
    owner = "nonamesc";
    repo = "yex-lang";
    rev = "a97def1431b73b8693700f530ec023f1776eaf83";
    sha256 = "074x9j0ihjpaghnwywq5zyxfad2h6m57c2i58wkz6chma6vcjk08";
    fetchSubmodules = true;
  };

  cargoSha256 = "017nszw07gzd2awadasxqyzx4zpb3y6db1zykcixddqxlyg1wwwq";

  meta = with lib; {
    description = "A cool functional scripting language written in rust";
    homepage = "https://github.com/yex-lang/yex-lang";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
