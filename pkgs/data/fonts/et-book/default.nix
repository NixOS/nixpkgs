{ stdenv, fetchFromGitHub }:

fetchFromGitHub rec {
  rev = "7e8f02dadcc23ba42b491b39e5bdf16e7b383031";
  name = "et-book-${builtins.substring 0 6 rev}";
  owner = "edwardtufte";
  repo = "et-book";
  sha256 = "1bfb1l8k7fzgk2l8cikiyfn5x9m0fiwrnsbc1483p8w3qp58s5n2";

  postFetch = ''
    tar -xzf $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp -t $out/share/fonts/truetype et-book-${rev}/source/4-ttf/*.ttf
  '';

  meta = with stdenv.lib; {
    description = "The typeface used in Edward Tufte’s books.";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ jethro ];
  };
}
