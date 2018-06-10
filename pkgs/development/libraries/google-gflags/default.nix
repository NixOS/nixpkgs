{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "google-gflags-${version}";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "gflags";
    repo = "gflags";
    rev = "v${version}";
    sha256 = "12wkihc4f07qmhyqk3cjylj8v5xz2bjrq75p7aq1vvvj60fbp58k";
  };

  nativeBuildInputs = [ cmake ];

  # This isn't used by the build and breaks the CMake build on case-insensitive filesystems (e.g., on Darwin)
  preConfigure = "rm BUILD";

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=ON"
    "-DBUILD_TESTING=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A C++ library that implements commandline flags processing";
    longDescription = ''
      The gflags package contains a C++ library that implements commandline flags processing.
      As such it's a replacement for getopt().
      It was owned by Google. google-gflags project has been renamed to gflags and maintained by new community.
    '';
    homepage = https://gflags.github.io/gflags/;
    license = licenses.bsd3;
    maintainers = [ maintainers.linquize ];
    platforms = platforms.all;
  };
}
