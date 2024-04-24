{ lib
, stdenv
, fetchFromGitHub
, cacert
, cmake
, cmakerc
, fmt
, git
, gzip
, makeWrapper
, meson
, ninja
, openssh
, python3
, zip
, zstd
, extraRuntimeDeps ? []
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vcpkg-tool";
  version = "2024-03-14";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vcpkg-tool";
    rev = finalAttrs.version;
    hash = "sha256-xe5a1cK56KvO4DFFz/K1omBCebzTRUOpXDpkOGek10M=";
  };

  nativeBuildInputs = [
    cmake
    cmakerc
    fmt
    ninja
    makeWrapper
  ];

  patches = [
    ./change-lock-location.patch
  ];

  cmakeFlags = [
    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON"
    "-DVCPKG_DEPENDENCY_CMAKERC=ON"
  ];

  postFixup = let
    # These are the most common binaries used by vcpkg
    # Extra binaries can be added via overlay when needed
    runtimeDeps = [
      cacert
      cmake
      git
      gzip
      meson
      ninja
      openssh
      python3
      zip
      zstd
    ] ++ extraRuntimeDeps;
  in ''
    wrapProgram $out/bin/vcpkg --prefix PATH ${lib.makeBinPath runtimeDeps}
  '';

  meta = {
    description = "Components of microsoft/vcpkg's binary";
    mainProgram = "vcpkg";
    homepage = "https://github.com/microsoft/vcpkg-tool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guekka gracicot ];
    platforms = lib.platforms.all;
  };
})
