{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "gandom-fonts";
  version = "0.6";

  src = fetchFromGitHub  {
    owner = "rastikerdar";
    repo = "gandom-font";
    rev = "v${version}";
    sha256 = "1pdbqhvcsz6aq3qgarhfd05ip0wmh7bxqkmxrwa0kgxsly6zxz9x";
  };

  meta = with lib; {
    homepage = "https://github.com/rastikerdar/gandom-font";
    description = "A Persian (Farsi) Font - فونت (قلم) فارسی گندم";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
