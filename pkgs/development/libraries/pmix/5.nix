{ lib, stdenv, fetchFromGitHub, perl, autoconf, automake
, libtool, flex, libevent, hwloc, munge, zlib, pandoc, git
, python3
} :

stdenv.mkDerivation rec {
  pname = "pmix";
  version = "5.0.1";

  src = fetchFromGitHub {
    repo = "openpmix";
    owner = "openpmix";
    rev = "v${version}";
    sha256 = "sha256-ZuuzQ8j5zqQ/9mBFEODAaoX9/doWB9Nt9Sl75JkJyqU=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
  '';

  nativeBuildInputs = [ pandoc perl autoconf automake libtool flex git python3 ];
  buildInputs = [ libevent hwloc munge zlib ];

  configureFlags = [
    "--with-libevent=${lib.getDev libevent}"
    "--with-libevent-libdir=${libevent}/lib"
    "--with-munge=${munge}"
    "--with-hwloc=${lib.getDev hwloc}"
    "--with-hwloc-libdir=${lib.getLib hwloc}/lib"
  ];

  preConfigure = ''
    ./autogen.pl
  '';

  postInstall = ''
    find $out/lib/ -name "*.la" -exec rm -f \{} \;
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Process Management Interface for HPC environments";
    homepage = "https://openpmix.github.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.linux;
  };
}
