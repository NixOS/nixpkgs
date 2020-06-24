{ stdenv, mkFont, fetchgit }:

mkFont {
  pname = "go-font";
  version = "2017-03-30";

  src = fetchgit {
    url = "https://go.googlesource.com/image";
    rev = "f03a046406d4d7fbfd4ed29f554da8f6114049fc";
    sha256 = "1aq6mnjayks55gd9ahavk6jfydlq5lm4xm0xk4pd5sqa74p5p74d";
  };

  meta = with stdenv.lib; {
    homepage = "https://blog.golang.org/go-fonts";
    description = "The Go font family";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
