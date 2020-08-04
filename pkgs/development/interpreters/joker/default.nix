{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "joker";
  version = "0.15.5";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "candid82";
    repo = "joker";
    sha256 = "0v4mamd5zkw7r9gfl4rzy4mr1d7ni9klryd93izqssgps954bikz";
  };

  vendorSha256 = "031ban30kx84r54fj9aq96pwkz9nqh4p9yzs4l8i1wqmy52rldvl";

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
