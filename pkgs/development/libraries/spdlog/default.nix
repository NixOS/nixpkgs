{ stdenv, fetchFromGitHub, cmake }:

let
  generic = { version, sha256 }:
    stdenv.mkDerivation {
      name = "spdlog-${version}";
      inherit version;

      src = fetchFromGitHub {
        owner  = "gabime";
        repo   = "spdlog";
        rev    = "v${version}";
        inherit sha256;
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
    };
in
{
  spdlog_1 = generic {
    version = "1.1.0";
    sha256 = "0yckz5w02v8193jhxihk9v4i8f6jafyg2a33amql0iclhk17da8f";
  };

  spdlog_0 = generic {
    version = "0.14.0";
    sha256 = "13730429gwlabi432ilpnja3sfvy0nn2719vnhhmii34xcdyc57q";
  };
}
