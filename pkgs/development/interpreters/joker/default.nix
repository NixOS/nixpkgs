{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "0.15.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "1pxj6flyhf522zjab1dfvxfajyx3v3rzs7l8ma7ma6b8zmwp2wdn";
  };

  vendorSha256 = "1rn8ijq3v3fzlbyvm7g4i3qpwcl3vrl4rbcvlbzv05wxrgcw9iqb";

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