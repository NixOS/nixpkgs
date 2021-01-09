{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, libmicrohttpd
}:
let
  build =
    { pname
    , subdir
    , buildInputs ? [ ]
    , description
    }:
    stdenv.mkDerivation rec {
      inherit pname;
      version = "0.1.3";

      src = fetchFromGitHub {
        owner = "digitalocean";
        repo = "prometheus-client-c";
        rev = "v${version}";
        sha256 = "0vsvng0nvvflcgick0bpyf8pynf0rzl2yk4mrydzbdkc6646s5sf";
      };

      nativeBuildInputs = [ cmake ];
      inherit buildInputs;

      preConfigure = ''
        cd ${subdir}
      '';

      meta = {
        homepage = "https://github.com/digitalocean/prometheus-client-c/";
        inherit description;
        platforms = stdenv.lib.platforms.unix;
        license = stdenv.lib.licenses.asl20;
        maintainers = [ stdenv.lib.maintainers.cfsmp3 ];
      };
    };
in
rec {
  libprom = build {
    pname = "libprom";
    subdir = "prom";
    description = "A Prometheus Client in C";
  };
  libpromhttp = build {
    pname = "libpromhttp";
    subdir = "promhttp";
    buildInputs = [ libmicrohttpd libprom ];
    description = "A Prometheus HTTP Endpoint in C";
  };
}
