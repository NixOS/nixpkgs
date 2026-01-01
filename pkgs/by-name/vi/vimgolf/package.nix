{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "vimgolf";
  gemdir = ./.;
  exes = [ "vimgolf" ];

  passthru.updateScript = bundlerUpdateScript "vimgolf";

<<<<<<< HEAD
  meta = {
    description = "Game that tests Vim efficiency";
    homepage = "https://vimgolf.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leungbk ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Game that tests Vim efficiency";
    homepage = "https://vimgolf.com";
    license = licenses.mit;
    maintainers = with maintainers; [ leungbk ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
