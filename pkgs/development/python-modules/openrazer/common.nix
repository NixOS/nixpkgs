{ lib
, fetchFromGitHub
}: rec {
  version = "3.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    hash = "sha256-tjVWvJxcZ2maR99VRwMGCa+IK+1CjCc7jxAj4XkDUEw=";
  };

  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ evanjs ] ++ teams.lumiguide.members;
    platforms = platforms.linux;
  };
}
