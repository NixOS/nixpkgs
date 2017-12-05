{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "spdlog-${version}";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    rev = "v${version}";
    sha256 = "0pfagrkq6afpkl269vbi1fd6ckakzpr5b5cbapb8rr7hgsrilxza";
  };

  buildInputs = [ cmake ];

  # cmakeFlags = [ "-DSPDLOG_BUILD_EXAMPLES=ON" ];

  outputs = [ "out" "doc" ];

  postInstall = ''
    mkdir -p $out/share/doc/spdlog
    cp -rv ../example $out/share/doc/spdlog
  '';

  meta = with stdenv.lib; {
    description    = "Very fast, header only, C++ logging library.";
    homepage       = https://github.com/gabime/spdlog;
    license        = licenses.mit;
    maintainers    = with maintainers; [ obadz ];
    platforms      = platforms.all;

    # This is a header-only library, no point in hydra building it:
    hydraPlatforms = [];
  };
}
