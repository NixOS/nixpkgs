{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "mxml";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mxml";
    rev = "v${version}";
    sha256 = "sha256-l7GUA+vlSECi/72eU3Y9COpGtLTRh3vYcHUi+uRkCn8=";
  };

  # remove the -arch flags which are set by default in the build
  configureFlags = lib.optionals stdenv.isDarwin [
    "--with-archflags=\"-mmacosx-version-min=10.14\""
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A small XML library";
    homepage = "https://www.msweet.org/mxml/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.goibhniu ];
  };
}
