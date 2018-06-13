{ stdenv, version, fetch, fetchpatch, cmake, python, llvm, libcxxabi }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "compiler-rt-${version}";
  inherit version;
  src = fetch "compiler-rt" "0p0y85c7izndbpg2l816z7z7558axq11d5pwkm4h11sdw7d13w0d";

  nativeBuildInputs = [ cmake python llvm ];
  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin libcxxabi;

  configureFlags = [
    "-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON"
  ];

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      name = "sigaltstack.patch"; # for glibc-2.26
      url = https://github.com/llvm-mirror/compiler-rt/commit/8a5e425a68d.diff;
      sha256 = "0h4y5vl74qaa7dl54b1fcyqalvlpd8zban2d1jxfkxpzyi7m8ifi";
    })
  ];

  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build. I realize that this LLVM isn't used in the stdenv but I want to
  # keep it consistent with 4.0. We really shouldn't be copying and pasting all this code around...
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/os_trace(\(.*\)");$/printf(\1\\n");/g' ./lib/sanitizer_common/sanitizer_mac.cc
  '';

  # Hack around weird upsream RPATH bug
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    ln -s "$out/lib"/*/* "$out/lib"
  '';

  enableParallelBuilding = true;
}
