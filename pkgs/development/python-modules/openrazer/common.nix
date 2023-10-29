{ lib
, fetchFromGitHub
}: rec {
  version = "3.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    hash = "sha256-bboTRZqJq5tKeBQuiEQAXxTHYvoldDQlwbfehjDA8EE=";
  };

  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ evanjs ] ++ teams.lumiguide.members;
    platforms = platforms.linux;
  };
}
