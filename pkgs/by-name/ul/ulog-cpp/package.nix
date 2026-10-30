{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doctest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ulog-cpp";
  version = "1.0.2-unstable-2026-09-22";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "PX4";
    repo = "ulog_cpp";
    rev = "5b18d22dbe9cc194ce4ff92d5f506659624423f5";
    hash = "sha256-D2fsr/SmATk6AFGLP0uWpVm5lxMJglKwCjErpM2/TaU=";
  };

  # CMakeLists.txt's own project(ulog_cpp VERSION 1.0.0 ...) has been
  # hardcoded at 1.0.0 since the v1.0.1 tag (and since, well past this pinned
  # commit) - never bumped alongside real releases/commits - so any
  # consumer's find_package(ulog_cpp 1.0.1) rejects this (chronologically
  # newer) checkout as "too old". Keep the installed Config's version
  # honest.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "VERSION 1.0.0" "VERSION ${builtins.elemAt (lib.splitString "-" finalAttrs.version) 0}"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ doctest ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "C++ library for reading and writing ULog files";
    homepage = "https://github.com/PX4/ulog_cpp";
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
