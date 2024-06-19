{ lib
, stdenv
, fetchFromGitHub
, cmake
, asciidoc
, pkg-config
, libsodium
, enableDrafts ? false
}:

stdenv.mkDerivation rec {
  pname = "zeromq";
  version = "4.3.5";

  src = fetchFromGitHub {
    owner = "zeromq";
    repo = "libzmq";
    rev = "v${version}";
    sha256 = "sha256-q2h5y0Asad+fGB9haO4Vg7a1ffO2JSb7czzlhmT3VmI=";
  };

  nativeBuildInputs = [ cmake asciidoc pkg-config ];
  buildInputs = [ libsodium ];

  doCheck = false; # fails all the tests (ctest)

  cmakeFlags = lib.optional enableDrafts "-DENABLE_DRAFTS=ON";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_LIBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '$'{prefix}/'$'{CMAKE_INSTALL_INCLUDEDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR}
  '';

  meta = with lib; {
    branch = "4";
    homepage = "http://www.zeromq.org";
    description = "The Intelligent Transport Layer";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
