{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libbsd-${version}";
  version = "0.8.7";

  src = fetchurl {
    url = "http://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "0c9bl49zs0xdddcwj5dh0lay9sxi2m1yi74848g8p87mb87g2j7m";
  };

  # darwin changes configure.ac which means we need to regenerate
  # the configure scripts
  nativeBuildInputs = [ autoreconfHook ];

  patches = stdenv.lib.optional stdenv.isDarwin ./darwin.patch
    # Suitable for all, but limited to musl to avoid rebuilds
    ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
      # https://cgit.freedesktop.org/libbsd/commit/?id=1f8a3f7bccfc84b195218ad0086ebd57049c3490
      ./non-glibc.patch
      # https://cgit.freedesktop.org/libbsd/commit/?id=11ec8f1e5dfa1c10e0c9fb94879b6f5b96ba52dd
      ./cdefs.patch
      # https://cgit.freedesktop.org/libbsd/commit/?id=b20272f5a966333b49fdf2bda797e2a9f0227404
      ./features.patch
  ];

  meta = with stdenv.lib; {
    description = "Common functions found on BSD systems";
    homepage = https://libbsd.freedesktop.org/;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
