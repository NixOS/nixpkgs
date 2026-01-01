{ lib, fetchFromGitHub }:
rec {
<<<<<<< HEAD
  version = "3.11.0";
=======
  version = "3.10.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openrazer";
    repo = "openrazer";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pk3nghd16jhdf7zokwMzBGwGtBU7ta4nSHsOoGxjD4w=";
=======
    hash = "sha256-M5g3Rn9WuyudhWQfDooopjexEgGVB0rzfJsPg+dqwn4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    homepage = "https://openrazer.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ evanjs ];
    teams = [ lib.teams.lumiguide ];
    platforms = lib.platforms.linux;
  };
}
