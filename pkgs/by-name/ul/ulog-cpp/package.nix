{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  nix-update-script,
}:

# TODO:
#  * Upstream Patche
#  * Upstream cmake file
stdenv.mkDerivation (finalAttrs: {
  pname = "ulog-cpp";
  version = "0-unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "ulog_cpp";
    rev = "eaac352b04501a49550fe6bcf02487b818c58f84";
    hash = "sha256-KNnZNiEDvBGUWsxUEEJhqBvZ5BiwQshImHyOfETltuM=";
  };
  customCmakeFile = ./ulog_cpp.cmake;

  patches = [
    ./system-doctest.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ doctest ];

  cmakeFlage = [ (lib.cmakeBool "MAIN_PROJECT" true)];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${finalAttrs.customCmakeFile} $out/lib/cmake/ulog_cpp/ulog_cpp.cmake
    install -Dm644 ./ulog_cpp/libulog_cpp.a $out/lib/libulog_cpp.a
    install -Dm755 ./ulog_writer $out/bin/ulog_writer
    install -Dm755 ./ulog_info $out/bin/ulog_info
    install -Dm755 ./ulog_data $out/bin/ulog_data
    for header in $(find ../ulog_cpp -type f -name "*.hpp"); do
      install -Dm644 "$header" $out/include/$(basename "$header")
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ library for reading and writing ULog files";
    homepage = "https://github.com/PX4/ulog_cpp";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})