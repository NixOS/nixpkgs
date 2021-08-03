{ lib
, clangStdenv
, cmake
, fetchFromGitHub
, git
, libtool
, lzma
, ninja
, pkg-config
, protobuf
, zlib
}:

let
  # See `src/cmake/external/googletest.cmake`.
  googletest_src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "release-1.11.0";
    sha256 = "sha256-SjlJxushfry13RGA7BCjYC9oZqV4z6x8dOiHfl/wpF0=";
  };
in
clangStdenv.mkDerivation rec {
  pname = "libprotobuf-mutator";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E4EL0c/v1IAZ7nDQQFRflls5BG5juUfq0ztTBuAGDXk=";
  };

  patches = [ ./local_googletest.patch ];

  postPatch = ''
    # Remove examples as they require to pull external repositories.
    rm -R examples/
    sed -e 's/add_subdirectory(examples EXCLUDE_FROM_ALL)//' -i CMakeLists.txt

    # Pulls an external git repository; Unused except in examples.
    rm cmake/external/expat.cmake

    cp -R ${googletest_src}/ googletest/
    chmod -R +w googletest
  '';

  nativeBuildInputs = [ cmake ninja pkg-config ];

  buildInputs = [ libtool lzma protobuf zlib ];

  cmakeFlags = [
    "-GNinja"
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
    "-DCMAKE_BUILD_TYPE=Debug"
    "-DPKG_CONFIG_PATH=share/pkgconfig"
  ];

  checkPhase = ''
    ninja check
  '';

  meta = with lib; {
    description = "A library to randomly mutate protobuffers";
    homepage = "https://github.com/google/libprotobuf-mutator";
    license = licenses.asl20;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
