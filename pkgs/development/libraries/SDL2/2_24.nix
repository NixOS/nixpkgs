{ fetchFromGitHub
, SDL2
}:

SDL2.overrideAttrs(oa: rec {
  version = "2.24.2";

  src = fetchFromGitHub {
    owner = "libsdl-org";
    repo = "SDL";
    rev = "refs/tags/release-${version}";
    hash = "sha256-DABzMQLVI/lnjijq0XJtZYUtMKX7E0WtFQCcnUXMZnY=";
  };
})
