{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, flask, pygments, dulwich, httpauth, humanize, pytest, requests, python-ctags3, mock }:

buildPythonPackage rec {
  pname = "klaus";
<<<<<<< HEAD
  version = "2.0.3";
=======
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-VAwIdmwdo/Rim2sVlR605Wo5/zkNOMiGkh40qLrENmU=";
=======
    hash = "sha256-kQcza2beyekJhRT9RwSdMIkeyapcUDtjgkapK3rocvg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  prePatch = ''
    substituteInPlace runtests.sh \
      --replace "mkdir -p \$builddir" "mkdir -p \$builddir && pwd"
  '';

  propagatedBuildInputs = [
    flask pygments dulwich httpauth humanize
  ];

  nativeCheckInputs = [
    pytest requests python-ctags3
  ] ++ lib.optional (!isPy3k) mock;

  checkPhase = ''
    ./runtests.sh
  '';

  # Needs to set up some git repos
  doCheck = false;

  meta = with lib; {
    description = "The first Git web viewer that Just Works";
    homepage    = "https://github.com/jonashaag/klaus";
    license     = licenses.isc;
    maintainers = with maintainers; [ pSub ];
  };
}
