{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cmake,
  zlib,
  openssl,
  c-ares,
  readline,
  icu,
  git,
  gbenchmark,
  nghttp2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tarantool";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "tarantool";
    repo = "tarantool";
    tag = finalAttrs.version;
    hash = "sha256-NU+0R07Qrnew7+HeeJu6QnGfktEXFRxSZFwl48vjGZE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cat <<'EOF' > third_party/luajit/test/cmake/GetLinuxDistro.cmake
    macro(GetLinuxDistro output)
      set(''${output} linux)
    endmacro()
    EOF
  '';

  buildInputs = [
    nghttp2
    git
    readline
    icu
    zlib
    openssl
    c-ares
  ];

  nativeCheckInputs = [ gbenchmark ];

  nativeBuildInputs = [
    autoreconfHook
    cmake
  ];

  preAutoreconf = ''
    pushd third_party/libunwind
  '';

  postAutoreconf = ''
    popd
  '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    "-DENABLE_DIST=ON"
    "-DTARANTOOL_VERSION=${finalAttrs.version}.builtByNix" # expects the commit hash as well
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "In-memory computing platform consisting of a database and an application server";
    homepage = "https://www.tarantool.io/";
    license = lib.licenses.bsd2;
    mainProgram = "tarantool";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
