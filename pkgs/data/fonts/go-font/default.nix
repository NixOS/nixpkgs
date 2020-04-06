{ stdenv, fetchgit }:

let
  version = "2017-03-30";
in (fetchgit {
  name = "go-font-${version}";
  url = "https://go.googlesource.com/image";
  rev = "f03a046406d4d7fbfd4ed29f554da8f6114049fc";

  postFetch = ''
    mv $out/* .
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/go-font
    cp font/gofont/ttfs/* $out/share/fonts/truetype
    mv $out/share/fonts/truetype/README $out/share/doc/go-font/LICENSE
  '';

  sha256 = "1488426ya2nzmwjas947fx9h5wzxrp9wasn8nkjqf0y0mpd4f1xz";
}) // {
  meta = with stdenv.lib; {
    homepage = https://blog.golang.org/go-fonts;
    description = "The Go font family";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
