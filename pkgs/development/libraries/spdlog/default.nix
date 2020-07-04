{ stdenv, fetchFromGitHub, cmake }:

let
  generic = { version, sha256 }:
    stdenv.mkDerivation {
      pname = "spdlog";
      inherit version;

      src = fetchFromGitHub {
        owner  = "gabime";
        repo   = "spdlog";
        rev    = "v${version}";
        inherit sha256;
      };

      nativeBuildInputs = [ cmake ];

      cmakeFlags = [ "-DSPDLOG_BUILD_EXAMPLE=OFF" "-DSPDLOG_BUILD_BENCH=OFF" ];

      outputs = [ "out" "doc" ];

      postInstall = ''
        mkdir -p $out/share/doc/spdlog
        cp -rv ../example $out/share/doc/spdlog
      '';

      meta = with stdenv.lib; {
        description    = "Very fast, header only, C++ logging library";
        homepage       = "https://github.com/gabime/spdlog";
        license        = licenses.mit;
        maintainers    = with maintainers; [ obadz ];
        platforms      = platforms.all;
      };
    };
in
{
  spdlog_1 = generic {
    version = "1.6.0";
    sha256 = "15fn8nd9xj7wrxcg9n4fjffid790qg2m366rx2lq2fc9v9walrxs";
  };

  spdlog_0 = generic {
    version = "0.17.0";
    sha256 = "112kfh4fbpm5cvrmgbgz4d8s802db91mhyjpg7cwhlywffnzkwr9";
  };
}
