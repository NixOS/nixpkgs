{ lib, stdenv
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
      version = "0.1.1";

      src = fetchFromGitHub {
        owner = "digitalocean";
        repo = "prometheus-client-c";
        rev = "v${version}";
        sha256 = "0g69s24xwrv5974acshrhnp6i8rpby8c6bhz15m3d8kpgjw3cm8f";
      };

      nativeBuildInputs = [ cmake ];
      inherit buildInputs;

      # These patches will be in 0.1.2
      patches = [
        # Required so CMAKE_INSTALL_PREFIX is honored, otherwise it
        # installs headers in /usr/include (absolute)
        (
          fetchpatch {
            url = "https://github.com/digitalocean/prometheus-client-c/commit/5fcedeb506b7d47dd7bab35797f2c3f23db6fe10.patch";
            sha256 = "10hzg8v5jcgxz224kdq0nha9vs78wz098b0ys7gig2iwgrg018fy";
          }
        )
        (
          fetchpatch {
            url = "https://github.com/digitalocean/prometheus-client-c/commit/0c15e7e45ad0c3726593591fdd7d8f2fde845fe3.patch";
            sha256 = "06899v1xz3lpsdxww4p3q7pv8nrymnibncdc472056znr5fidlp0";
          }
        )
      ];

      preConfigure = ''
        cd ${subdir}
      '';

      meta = {
        homepage = "https://github.com/digitalocean/prometheus-client-c/";
        inherit description;
        platforms = lib.platforms.unix;
        license = lib.licenses.asl20;
        maintainers = [ lib.maintainers.cfsmp3 ];
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
