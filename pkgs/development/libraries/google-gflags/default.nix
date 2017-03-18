{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "google-gflags-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "gflags";
    repo = "gflags";
    rev = "v${version}";
    sha256 = "1y5808ky8qhjwv1nf134czz0h2p2faqvjhxa9zxf8mg8hn4ns9wp";
  };

  nativeBuildInputs = [ cmake ];

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
