{ lib
, fetchFromGitHub
}: rec {
  version = "3.3.0";
  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    rev = "v${version}";
    sha256 = "1lw2cpj2xzwcsn5igrqj3f6m2v5n6zp1xa9vv3j9f9r2fbb48jcl";
  };
  meta = with lib; {
    homepage = "https://openrazer.github.io/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ evanjs ] ++ teams.lumiguide.members;
    platforms = platforms.linux;
  };
}
