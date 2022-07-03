{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "yex-lang";
  version = "0.pre+date=2022-05-10";

  src = fetchFromGitHub {
    owner = "nonamescm";
    repo = "yex-lang";
    rev = "866c4decbb9340f5af687b145e2c4f47fcbee786";
    hash = "sha256-sxzkZ2Rhn3HvZIfjnJ6Z2au/l/jV5705ecs/X3Iah6k=";
  };

  cargoSha256 = "sha256-nX5FoPAk50wt0CXskyg7jQeHvD5YtBNnCe0CVOGXTMI=";

  meta = with lib; {
    homepage = "https://github.com/nonamescm/yex-lang";
    description = "A functional scripting language written in rust";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    mainProgram = "yex";
    platforms = platforms.unix;
    broken = stdenv.isAarch64 && stdenv.isLinux;
  };
}
