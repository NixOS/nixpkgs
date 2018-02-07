{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "spdlog-${version}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner  = "gabime";
    repo   = "spdlog";
    rev    = "v${version}";
    sha256 = "13730429gwlabi432ilpnja3sfvy0nn2719vnhhmii34xcdyc57q";
  };

  nativeBuildInputs = [ cmake ];

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
  };
}
