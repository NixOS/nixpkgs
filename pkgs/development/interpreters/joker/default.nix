{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "0.15.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "03lbvxmkn0rr7yv7kj6c4dh4zayiwbhrkqbz2m22dw568rjbp8az";
  };

  modSha256 = "1mylgim9nm0v5wybgzi74nqzmvzwzws0027wzl86dbj5id83ab9v";

  preBuild = ''
    go generate ./...
  '';

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/candid82/joker";
    description = "A small Clojure interpreter and linter written in Go";
    license = licenses.epl10;
    platforms = platforms.all;
    maintainers = with maintainers; [ andrestylianos ];
  };
}
