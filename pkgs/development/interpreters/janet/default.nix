{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "janet";
<<<<<<< HEAD
  version = "1.30.0";
=======
  version = "1.27.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tkXEi8m7eroie/yP1kW0V6Ld5SCLA0/KmtHHI0fIsRI=";
=======
    sha256 = "sha256-UsM7J1LsiO5g3yxpO245Yr0oJQaCxs7LMNvxuHv6pTk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace janet.1 \
      --replace /usr/local/ $out/
  '';

  nativeBuildInputs = [ meson ninja ];

<<<<<<< HEAD
  mesonBuildType = "release";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  mesonFlags = [ "-Dgit_hash=release" ];

  doCheck = true;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/janet -e '(+ 1 2 3)'
  '';

  meta = with lib; {
    description = "Janet programming language";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewchambers peterhoeg ];
    platforms = platforms.all;
  };
}
