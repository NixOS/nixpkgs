{ lib, mkFont, fetchFromGitHub, fontforge }:

mkFont rec {
  pname = "gubbi-font";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "aravindavk";
    repo = "gubbi";
    rev = "v${version}";
    sha256 = "10w9i3pmjvs1b3xclrgn4q5a95ss4ipldbxbqrys2dmfivx7i994";
  };

  nativeBuildInputs = [ fontforge ];
  dontBuild = false;
  preBuild = "patchShebangs generate.pe";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A Kannada font";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ ehmry ];
  };
}
