{ lib, stdenv, fetchFromGitHub, fontforge }:

stdenv.mkDerivation rec {
  pname = "gubbi-font";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "aravindavk";
    repo = "gubbi";
    rev = "v${version}";
    sha256 = "10w9i3pmjvs1b3xclrgn4q5a95ss4ipldbxbqrys2dmfivx7i994";
  };

  nativeBuildInputs = [ fontforge ];

  dontConfigure = true;

  preBuild = "patchShebangs generate.pe";

  installPhase = "install -Dm444 -t $out/share/fonts/truetype/ Gubbi.ttf";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Kannada font";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
  };
}
