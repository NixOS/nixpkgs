{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libbsd";
  version = "0.9.1";

  src = fetchurl {
    url = "https://libbsd.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1957w2wi7iqar978qlfsm220dwywnrh5m58nrnn9zmi74ds3bn2n";
  };

  # darwin changes configure.ac which means we need to regenerate
  # the configure scripts
  nativeBuildInputs = [ autoreconfHook ];

  patches = stdenv.lib.optional stdenv.isDarwin ./darwin.patch
    # Suitable for all but limited to musl to avoid rebuild
    ++ stdenv.lib.optional stdenv.hostPlatform.isMusl ./musl.patch;

  meta = with stdenv.lib; {
    description = "Common functions found on BSD systems";
    homepage = https://libbsd.freedesktop.org/;
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
