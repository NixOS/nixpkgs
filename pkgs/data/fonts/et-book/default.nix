{ stdenv, mkFont, fetchFromGitHub }:

mkFont {
  pname = "et-book";
  version = "2015-10-05";

  src = fetchFromGitHub rec {
    owner = "edwardtufte";
    repo = "et-book";
    rev = "7e8f02dadcc23ba42b491b39e5bdf16e7b383031";
    sha256 = "16n6pid29m64bsrlgm7wbylz0wa89c7zyhijy5s8ldlvv05z5ah7";
  };

  meta = with stdenv.lib; {
    description = "The typeface used in Edward Tufte’s books.";
    homepage = "https://github.com/edwardtufte/et-book";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jethro ];
  };
}
