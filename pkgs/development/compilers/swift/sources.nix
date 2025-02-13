{ lib, fetchFromGitHub }:

let

  # These packages are all part of the Swift toolchain, and have a single
  # upstream version that should match. We also list the hashes here so a basic
  # version upgrade touches only this file.
  version = "5.8";
  hashes = {
    llvm-project = "sha256-0xwSAwwkzFgYO3mY1rHqV8TCeH2NpM7m3VUkCDqjcdE=";
    sourcekit-lsp = "sha256-XDGq64LbpgBrRy3IvZNgsoLUePXECK5p10vQ8cUKeGE=";
    swift = "sha256-EY2IImBCVLiUutvDQjNUiInwCNxZsCu1mZzYSjNd4+A=";
    swift-cmark = "sha256-6xkO9kN6eXMAigjk+KyIgVhTyC50BxmkZmD4+9z6nz8=";
    swift-corelibs-foundation = "sha256-yRjjxJRy1eTM9VG7/Fn60UMghPavsaoueH0V8cjaIyM=";
    swift-corelibs-libdispatch = "sha256-XOAWuaGqWJtxhGIPXYT3PIvk5OK0rkY4g1IOybJUlm4=";
    swift-corelibs-xctest = "sha256-uwxQhKUQ1xp5ao6kfkdlYOvMr6yAb5IaBIdOfoyf+n8=";
    swift-docc = "sha256-k1ygYDZwF4Jo7iOkHxc/3NzfgN+8XNCks5aizxBgPjM=";
    swift-docc-render-artifact = "sha256-vdSyICXOjlNSjZXzPRxa/5305pg6PG4xww9GYEV9m10=";
    swift-driver = "sha256-7xsG3Bpf+wqisCMaPEuEg8CjGYO/0r8BX3pMUmRrezE=";
    swift-experimental-string-processing = "sha256-ioXG6pQKjlAc2oF38Z7TGighyZN8w2ZAAtFUq83Ow6Q=";
    swift-format = "sha256-uKhIcbJb0DDHKACfVrhQ4fSyXVUkAj090eUZsOrtEqw=";
    swift-package-manager = "sha256-xd6ZpeXfMoHyVrJxz6XcDLPKBvc2nl1lgWXuLrJdq+E=";
    swift-syntax = "sha256-gkpx/1sWWi9y917OJ1GSNFYXrJb6e2qI4JlV+38laRQ=";
  };

  # Create fetch derivations.
  sources = lib.mapAttrs (
    repo: hash:
    fetchFromGitHub {
      owner = "apple";
      inherit repo;
      rev = "swift-${version}-RELEASE";
      name = "${repo}-${version}-src";
      hash = hashes.${repo};
    }
  ) hashes;

in
sources // { inherit version; }
