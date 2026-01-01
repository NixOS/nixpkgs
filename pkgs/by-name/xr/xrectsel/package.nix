{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libX11,
}:

stdenv.mkDerivation rec {
  pname = "xrectsel";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ropery";
    repo = "xrectsel";
    rev = version;
    sha256 = "0prl4ky3xzch6xcb673mcixk998d40ngim5dqc5374b1ls2r6n7l";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libX11 ];

<<<<<<< HEAD
  meta = {
    description = "Print the geometry of a rectangular screen region";
    homepage = "https://github.com/ropery/xrectsel";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Print the geometry of a rectangular screen region";
    homepage = "https://github.com/ropery/xrectsel";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "xrectsel";
  };
}
