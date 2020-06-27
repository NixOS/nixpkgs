{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "libre-franklin";
  version = "1.014";

  src = fetchFromGitHub {
    owner = "impallari";
    repo = "Libre-Franklin";
    rev = "006293f34c47bd752fdcf91807510bc3f91a0bd3";
    sha256 = "0df41cqhw5dz3g641n4nd2jlqjf5m4fkv067afk3759m4hg4l78r";
  };

  meta = with lib; {
    description = "A reinterpretation and expansion based on the 1912 Morris Fuller Benton’s classic.";
    homepage = "https://github.com/impallari/Libre-Franklin";
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
