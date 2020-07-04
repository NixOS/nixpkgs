{ gccStdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:
let
  stdenv = gccStdenv; # Darwin is clang by default and it doesn't work for this.
in
stdenv.mkDerivation rec {
  pname = "libprom";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "prometheus-client-c";
    rev = "v${version}";
    sha256 = "0g69s24xwrv5974acshrhnp6i8rpby8c6bhz15m3d8kpgjw3cm8f";
  };

  nativeBuildInputs = [ cmake ];
  doCheck = false;

  patches = [
     # Required so CMAKE_INSTALL_PREFIX is honored, otherwise it
     # installs headers in /usr/include (absolute)
    (fetchpatch {
      url = "https://github.com/digitalocean/prometheus-client-c/commit/5fcedeb506b7d47dd7bab35797f2c3f23db6fe10.patch";
      sha256 = "10hzg8v5jcgxz224kdq0nha9vs78wz098b0ys7gig2iwgrg018fy";
    }) 
    (fetchpatch {
      url = "https://github.com/digitalocean/prometheus-client-c/commit/0c15e7e45ad0c3726593591fdd7d8f2fde845fe3.patch";
      sha256 = "06899v1xz3lpsdxww4p3q7pv8nrymnibncdc472056znr5fidlp0";
    }) 
  ];

  preConfigure = ''
    cd prom
  '';

  meta = {
    homepage = "https://github.com/digitalocean/prometheus-client-c/";
    description = "A Prometheus Client in C";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.cfsmp3 ];
  };

}
