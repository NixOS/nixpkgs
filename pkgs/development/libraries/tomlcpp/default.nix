{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "tomlcpp";
  version = "0.pre+date=2022-05-01";

  src = fetchFromGitHub {
    owner = "cktan";
    repo = pname;
    rev = "59fcc6dc89fb3f4130a2865e41e1fa5b8c502e45";
    hash = "sha256-Uc6R5KnGIZXY0EJgFM4Xi7Jtxcu6l8yGh5xgFZPoJDM=";
  };

  patches = [
    # Self-explaining
    ./0001-missing-headers.diff
  ];

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
