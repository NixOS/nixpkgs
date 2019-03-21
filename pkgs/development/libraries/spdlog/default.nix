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

      cmakeFlags = [ "-DSPDLOG_BUILD_EXAMPLES=OFF" ];

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
    version = "1.2.1";
    sha256 = "0gdj8arfz4r9419zbcxk9y9nv47qr7kyjjzw9m3ijgmn2pmxk88n";
  };

  spdlog_0 = generic {
    version = "0.17.0";
    sha256 = "112kfh4fbpm5cvrmgbgz4d8s802db91mhyjpg7cwhlywffnzkwr9";
  };
}
