{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "spdlog-${version}";
  version = stdenv.lib.strings.substring 0 7 rev;
  rev = "292bdc5eb4929f183c78d2c67082b715306f81c9";

  src = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    inherit rev;
    sha256 = "1b6b0c81a8hisaibqlzj5mrk3snrfl8p5sqa056q2f02i62zksbn";
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
