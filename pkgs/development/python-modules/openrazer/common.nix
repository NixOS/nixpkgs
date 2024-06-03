{ lib, fetchFromGitHub }:
rec {
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    hash = "sha256-eV5xDFRQi0m95pL6e2phvblUbh5GEJ1ru1a62TnbGNk=";
  };

  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ evanjs ] ++ teams.lumiguide.members;
    platforms = platforms.linux;
  };
}
