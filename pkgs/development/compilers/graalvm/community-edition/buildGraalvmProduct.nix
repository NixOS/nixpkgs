{ lib
, stdenv
, autoPatchelfHook
, makeWrapper
, perl
, unzip
, zlib
}:
{ product
, javaVersion
, extraNativeBuildInputs ? [ ]
, extraBuildInputs ? [ ]
, meta ? { }
, passthru ? { }
, ... } @ args:

stdenv.mkDerivation (args // {
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

  dontInstall = true;
  dontBuild = true;
  dontStrip = true;
  # installCheckPhase is going to run in GraalVM main derivation (see buildGraalvm.nix)
  # to make sure that it has everything it needs to run correctly.
  # Other hooks like fixupPhase/installPhase are also going to run there for the
  # same reason.
  doInstallCheck = false;

  passthru = { inherit product; } // passthru;

  meta = with lib; ({
    homepage = "https://www.graalvm.org/";
    description = "High-Performance Polyglot VM (Product: ${product})";
    license = with licenses; [ upl gpl2Classpath bsd3 ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; teams.graalvm-ce.members ++ [ ];
  } // meta);
})
