{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tomlcpp";
  version = "0.pre+date=2022-06-25";

  src = fetchFromGitHub {
    owner = "cktan";
    repo = pname;
    rev = "4212f1fccf530e276a2e1b63d3f99fbfb84e86a4";
    hash = "sha256-PM3gURXhyTZr59BWuLHvltjKOlKUSBT9/rqTeX5V//k=";
  };

  dontConfigure = true;

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  meta = with lib;{
    homepage = "https://github.com/cktan/tomlcpp";
    description = "No fanfare TOML C++ Library";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
