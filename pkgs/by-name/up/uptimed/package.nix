{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "uptimed";
  version = "0.4.7";

  src = fetchFromGitHub {
    sha256 = "sha256-gP6Syzu54/co4L+UCPikUhXDpxpfAB4jO/5ZF/9RdN0=";
    rev = "v${version}";
    repo = "uptimed";
    owner = "rpodgorny";
  };

  nativeBuildInputs = [ autoreconfHook ];
  patches = [ ./no-var-spool-install.patch ];

  postPatch = ''
    substituteInPlace libuptimed/urec.h \
      --replace /var/spool /var/lib
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Uptime record daemon";
    longDescription = ''
      An uptime record daemon keeping track of the highest uptimes a computer
      system ever had. It uses the system boot time to keep sessions apart from
      each other. Uptimed comes with a console front-end to parse the records,
      which can also easily be used to show your records on a web page.
    '';
    homepage = "https://github.com/rpodgorny/uptimed/";
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2Only
      lgpl21Plus
    ];
    maintainers = [ ];
<<<<<<< HEAD
    platforms = lib.platforms.linux;
=======
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
