{ stdenv, fetchFromGitHub, perl, autoconf, automake
, libtool, flex, libevent, hwloc, munge, zlib, pandoc
} :

let
  version = "3.2.2";

in stdenv.mkDerivation {
  pname = "pmix";
  inherit version;

  src = fetchFromGitHub {
    repo = "openpmix";
    owner = "openpmix";
    rev = "v${version}";
    sha256 = "1rf82z7h76366qknkmralmslsfmihv0r3ymhbgk1axq97ic3g4d7";
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

  meta = with stdenv.lib; {
    description = "Process Management Interface for HPC environments";
    homepage = "https://openpmix.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}

