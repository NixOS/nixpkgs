
{ stdenv
, fetchFromGitHub
, cmake
, pkg-config
, boost
, gsl
, eigen
, gnuplot
}:

stdenv.mkDerivation rec {
  pname = "ygor";
  version = "20200415.1";

  src = fetchFromGitHub {
    owner = "hdclark";
    repo = "ygor";

    # Reminder: the sha256 hash can be computed via:
    #  nix-prefetch-url --unpack "https://github.com/hdclark/ygor/archive/${rev}.tar.gz"
    #
    rev = "eeedfb6a8ac4092f7391f1f7530b72ff5cf3c1e9";
    sha256 = "1x0mcamy74bk4fbv27ainxar0wwx6k57i0x7vy0m4dcx56j0rl8j";
  };

  nativeBuildInputs = [ 
    cmake 
    pkg-config 
  ];

  buildInputs = [ 
    boost
    gsl
    eigen
    gnuplot
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release"
                 "-DWITH_LINUX_SYS=ON"
                 "-DWITH_EIGEN=ON"
                 "-DWITH_GNU_GSL=ON"
                 "-DWITH_BOOST=ON" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Support library with scientific emphasis";
    longDescription = ''
      Ygor was written to factor common code amongst a handful of disparate projects.

      Most, but not all of Ygor's routines are focused on scientific or mathematic
      applications. These routines will grow, be replaced, be updated, and may even
      disappear when their functionality is superceded by new features in the
      language/better libraries/etc. However, many of these routines are not broadly
      useful enough for a project like Boost to include, and many are not
      comprehensive enough to be submitted to more mature projects. The routines in
      this library were all developed for specific projects with specific needs, but
      which may (have) become useful for other projects.
    '';
    homepage    = "http://halclark.ca";
    license     = stdenv.lib.licenses.gpl3Plus;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ halclark ];
  };
}

