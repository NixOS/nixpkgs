{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "libbsd-${version}";
  version = "0.9.1";

  src = fetchurl {
    url = "https://libbsd.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1957w2wi7iqar978qlfsm220dwywnrh5m58nrnn9zmi74ds3bn2n";
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
