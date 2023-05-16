{ lib
, stdenv
, fetchFromGitHub
, cmake
<<<<<<< HEAD
, llvmPackages
, libxml2
, zlib
, coreutils
, callPackage
}@args:

import ./generic.nix args {
  version = "0.10.1";

  hash = "sha256-69QIkkKzApOGfrBdgtmxFMDytRkSh+0YiaJQPbXsBeo=";

  outputs = [ "out" "doc" ];

  patches = [
    # Backport alignment related panics from zig-master to 0.10.
    # Upstream issue: https://github.com/ziglang/zig/issues/14559
    ./002-0.10-macho-fixes.patch
  ];

=======
, coreutils
, llvmPackages
, libxml2
, zlib
}:

stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.10.1";
  outputs = [ "out" "doc" ];

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = version;
    hash = "sha256-69QIkkKzApOGfrBdgtmxFMDytRkSh+0YiaJQPbXsBeo=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];

  buildInputs = [
    coreutils
    libxml2
    zlib
  ] ++ (with llvmPackages; [
    libclang
    lld
    llvm
  ]);

  patches = [
    # Backport alignment related panics from zig-master to 0.10.
    # Upstream issue: https://github.com/ziglang/zig/issues/14559
    ./zig_14559.patch
  ];

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  postPatch = ''
    # Zig's build looks at /usr/bin/env to find dynamic linking info. This
    # doesn't work in Nix' sandbox. Use env from our coreutils instead.
    substituteInPlace lib/std/zig/system/NativeTargetInfo.zig --replace "/usr/bin/env" "${coreutils}/bin/env"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # always link against static build of LLVM
    "-DZIG_STATIC_LLVM=ON"

    # ensure determinism in the compiler build
    "-DZIG_TARGET_MCPU=baseline"
  ];

  postBuild = ''
<<<<<<< HEAD
    ./zig2 run ../doc/docgen.zig -- ./zig2 ../doc/langref.html.in langref.html
  '';

  postInstall = ''
    install -Dm644 -t $doc/share/doc/zig-$version/html ./langref.html
  '';
=======
    ./zig2 build-exe ../doc/docgen.zig
    ./docgen ./zig2 ../doc/langref.html.in ./langref.html
  '';

  doCheck = true;

  postInstall = ''
    install -Dm644 -t $doc/share/doc/$pname-$version/html ./langref.html
  '';

  installCheckPhase = ''
    $out/bin/zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
  '';

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description =
      "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [ aiotter andrewrk AndersonTorres ];
    platforms = platforms.unix;
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
