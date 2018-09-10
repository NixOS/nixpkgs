{ stdenv, fetchFromGitHub }:

fetchFromGitHub rec {
  rev = "1.0";
  name = "et-book-${rev}";
  owner = "jethrokuan";
  repo = "et-book";
  sha256 = "1bfb1l8k7fzgk2l8cikiyfn5x9m0fiwrnsbc1483p8w3qp58s5n2";

  postFetch = ''
    tar -xzf $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp -t $out/share/fonts/truetype ${name}/*.ttf
  '';

  meta = with stdenv.lib; {
    description = "Font for ET Book";
    license = licenses.free;
    platforms = platforms.all;
    maintainers = with maintainers; [ jethro ];
  };
}
