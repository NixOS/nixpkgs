{ lib, fetchFromGitHub }:
rec {
  version = "3.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    tag = "v${version}";
    hash = "sha256-iXMN/wFe0IWr9kwGmuU+j/n2DHvxP37VqY/NVn8F690=";
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ];
    platforms = lib.platforms.linux;
  };
}
