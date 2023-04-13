{ lib
, stdenv
, fetchFromGitHub
, catch2
, cmake
, expected-lite
, fmt
, gsl-lite
, ninja
}:

stdenv.mkDerivation rec {
  pname = "bencode";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fbdtemme";
    repo = "bencode";
    rev = version;
    hash = "sha256-zpxvADZfYTUdlNLMZJSCanPL40EGl9BBCxR7oDhvOTw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    catch2
    expected-lite
    fmt
    gsl-lite
  ];

  postPatch = ''
    # Disable a test that requires an internet connection.
    substituteInPlace tests/CMakeLists.txt \
      --replace "add_subdirectory(cmake_fetch_content)" ""
  '';

  doCheck = true;

  postInstall = ''
    rm -rf $out/lib64
  '';

  meta = with lib; {
    description = "A header-only C++20 bencode serialization/deserialization library";
    homepage = "https://github.com/fbdtemme/bencode";
    changelog = "https://github.com/fbdtemme/bencode/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
    # Broken because the default stdenv on these targets doesn't support C++20.
    broken = with stdenv; isDarwin || (isLinux && isAarch64);
  };
}
