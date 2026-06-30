{
  lib,
  buildLakePackage,
  fetchFromGitHub,
}:

buildLakePackage {
  pname = "lean4-Qq";
  # nixpkgs-update: no auto update
  version = "4.31.0-unstable-2026-06-15";

  src = fetchFromGitHub {
    owner = "leanprover-community";
    repo = "quote4";
    rev = "f46324995fca5f0483b742e4eb4daec7f4ee50d2";
    hash = "sha256-WUxmVOyKclhASP+galjYy2y/lYJbTizTKuRhDV6oPFs=";
  };

  leanPackageName = "Qq";

  meta = {
    description = "Lean 4 compile-time quote and antiquote macros for metaprogramming";
    homepage = "https://github.com/leanprover-community/quote4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nadja-y ];
  };
}
