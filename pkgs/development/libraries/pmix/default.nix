{ lib, stdenv, fetchFromGitHub, perl, autoconf, automake
, libtool, flex, libevent, hwloc, munge, zlib, pandoc
} :

stdenv.mkDerivation rec {
  pname = "pmix";
  version = "3.2.4";

  src = fetchFromGitHub {
    repo = "openpmix";
    owner = "openpmix";
    rev = "v${version}";
    sha256 = "sha256-79zTZm549VRsqeziCuBT6l4jTJ6D/gZaMAvgHZm7jn4=";
  };

  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
  '';

  nativeBuildInputs = [ pandoc perl autoconf automake libtool flex ];

  buildInputs = [ libevent hwloc munge zlib ];

  configureFlags = [
    "--with-libevent=${libevent.dev}"
    "--with-munge=${munge}"
    "--with-hwloc=${hwloc.dev}"
  ];

  preConfigure = ''
    ./autogen.pl
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Process Management Interface for HPC environments";
    homepage = "https://openpmix.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}

