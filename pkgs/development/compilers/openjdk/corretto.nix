{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, bash
, openjdk8

, ...
}:

let
  version = "8.212.04.2";
  src = fetchFromGitHub {
    owner  = "corretto";
    repo   = "corretto-8";
    rev    = "709b72ea0c99171cc284e220b844dc333d9e6880";
    sha256 = "0p16vp959q9wyrj74jqdg0708mljbbjra87vjkm10bnd40wg1ia2";
  };

  name = "corretto-${version}";

  # In the form: $MAJOR.$UPDATE.$BUILD.$REVISION
  tokens = lib.splitString "." version;

  majorVersion     = builtins.elemAt tokens 0;
  updateVersion    = builtins.elemAt tokens 1;
  buildNumber      = builtins.elemAt tokens 2;
  correttoRevision = builtins.elemAt tokens 3;

  corretto = openjdk8.overrideAttrs (oldAttrs: rec {
    inherit name version src;

    # Override upstream sources and directory auto-detection; Corretto includes
    # everything in the same repository.
    srcs = null;
    sourceRoot = null;

    # OpenJDK sources in the repo are stored under './src'
    postUnpack = ''
      sourceRoot+=/src
    '' + (oldAttrs.postUnpack or "");

    # Don't need the 'move everything to the same directory' steps that the main
    # recipe does.
    prePatch = null;

    patches = oldAttrs.patches ++ [
      # Suppress an error from -Wformat
      (fetchpatch {
        url = "http://icedtea.classpath.org/hg/icedtea8/raw-file/cea1a48810dd/patches/pr3597.patch";
        sha256 = "1dy79l5jq8npdx35i9aq9xai5lz9k35db65phkvham69ch4564g7";
      })
    ];

    # The configure script isn't marked as executable, so we need to run it
    # directly with Bash.
    configureScript = "${bash}/bin/bash ./configure";

    # Pass correct build versions
    configureFlags = oldAttrs.configureFlags ++[
      "--with-update-version=${updateVersion}"
      "--with-build-number=b${buildNumber}"
      "--with-corretto-revision=${correttoRevision}"
      "--disable-zip-debug-info"
    ];

    # Needed because otherwise we get a warning about _FORTIFY_SOURCE
    NIX_CFLAGS_COMPILE = "-O1";

    meta = with stdenv.lib; {
      homepage = https://aws.amazon.com/corretto/;
      license = licenses.gpl2Classpath;
      description = "No-cost, multiplatform, production-ready distribution of OpenJDK";
      maintainers = with maintainers; [ andrew-d ];
      platforms = platforms.linux;
    };

    passthru = {
      inherit (openjdk8) architecture;
      home = "${corretto}/lib/openjdk";
    };
  });

in corretto
