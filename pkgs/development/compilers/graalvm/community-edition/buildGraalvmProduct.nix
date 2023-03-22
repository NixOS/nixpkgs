{ lib
, stdenv
, autoPatchelfHook
, graalvm-ce
, makeWrapper
, perl
, unzip
, zlib
  # extra params
, product
, javaVersion
, extraBuildInputs ? [ ]
, extraNativeBuildInputs ? [ ]
, graalvmPhases ? { }
, meta ? { }
, passthru ? { }
, ...
} @ args:

let
  extraArgs = builtins.removeAttrs args [
    "lib"
    "stdenv"
    "autoPatchelfHook"
    "graalvm-ce"
    "makeWrapper"
    "perl"
    "unzip"
    "zlib"
    "product"
    "javaVersion"
    "extraBuildInputs"
    "extraNativeBuildInputs"
    "graalvmPhases"
    "meta"
    "passthru"
  ];
in
stdenv.mkDerivation ({
  pname = "${product}-java${javaVersion}";

  nativeBuildInputs = [ perl unzip makeWrapper ]
    ++ lib.optional stdenv.isLinux autoPatchelfHook
    ++ extraNativeBuildInputs;

  buildInputs = [
    stdenv.cc.cc.lib # libstdc++.so.6
    zlib
  ] ++ extraBuildInputs;

  unpackPhase = ''
    runHook preUnpack

    unpack_jar() {
      local jar="$1"
      unzip -q -o "$jar" -d "$out"
      perl -ne 'use File::Path qw(make_path);
                use File::Basename qw(dirname);
                if (/^(.+) = (.+)$/) {
                  make_path dirname("$ENV{out}/$1");
                  symlink $2, "$ENV{out}/$1";
                }' "$out/META-INF/symlinks"
      perl -ne 'if (/^(.+) = ([r-])([w-])([x-])([r-])([w-])([x-])([r-])([w-])([x-])$/) {
                  my $mode = ($2 eq 'r' ? 0400 : 0) + ($3 eq 'w' ? 0200 : 0) + ($4  eq 'x' ? 0100 : 0) +
                              ($5 eq 'r' ? 0040 : 0) + ($6 eq 'w' ? 0020 : 0) + ($7  eq 'x' ? 0010 : 0) +
                              ($8 eq 'r' ? 0004 : 0) + ($9 eq 'w' ? 0002 : 0) + ($10 eq 'x' ? 0001 : 0);
                  chmod $mode, "$ENV{out}/$1";
                }' "$out/META-INF/permissions"
      rm -rf "$out/META-INF"
    }

    unpack_jar "$src"

    runHook postUnpack
  '';

  # Allow autoPatchelf to automatically fix lib references between products
  fixupPhase = ''
    runHook preFixup

    mkdir -p $out/lib
    shopt -s globstar
    ln -s $out/languages/**/lib/*.so $out/lib

    runHook postFixup
  '';

  dontInstall = true;
  dontBuild = true;
  dontStrip = true;

  passthru = {
    inherit product javaVersion;
    # build phases that are going to run during GraalVM derivation build,
    # since they depend in having the fully setup GraalVM environment
    # e.g.: graalvmPhases.installCheckPhase will run the checks only after
    # GraalVM+products is build
    # see buildGraalvm.nix file for the available phases
    inherit graalvmPhases;
  } // passthru;

  meta = with lib; ({
    inherit (graalvm-ce.meta) homepage license sourceProvenance maintainers platforms;
    description = "High-Performance Polyglot VM (Product: ${product})";
  } // meta);
} // extraArgs)
