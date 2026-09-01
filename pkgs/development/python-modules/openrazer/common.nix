{ lib, fetchFromGitHub }:
rec {
  version = "3.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    tag = "v${version}";
    hash = "sha256-WgDYs0ehnzWlX/wvfur0UhFLbZv7jZ6FMybqDaFDuLg=";
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    changelog = "https://github.com/openrazer/openrazer/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = lib.platforms.linux;
  };
}
