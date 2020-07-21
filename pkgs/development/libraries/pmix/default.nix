{ stdenv, fetchFromGitHub, perl, autoconf, automake
, libtool, flex, libevent, hwloc, munge, zlib
} :

let
  version = "3.1.5";

in stdenv.mkDerivation {
  pname = "pmix";
  inherit version;

  src = fetchFromGitHub {
    repo = "openpmix";
    owner = "openpmix";
    rev = "v${version}";
    sha256 = "0fvfsig20amcigyn4v3gcdxc0jif44vqg37b8zzh0s8jqqj7jz5w";
  };

  postPatch = ''
    patchShebangs ./autogen.pl
    patchShebangs ./config
  '';

  nativeBuildInputs = [ perl autoconf automake libtool flex ];

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

  meta = with stdenv.lib; {
    description = "Process Management Interface for HPC environments";
    homepage = "https://openpmix.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}

