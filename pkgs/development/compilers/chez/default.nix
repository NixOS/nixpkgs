{ lib, stdenv, fetchFromGitHub
, coreutils, cctools
, ncurses, libiconv, libX11, libuuid
}:

stdenv.mkDerivation rec {
  pname = "chez-scheme";
  version = "9.5.8";

  src = fetchFromGitHub {
    owner  = "cisco";
    repo   = "ChezScheme";
    rev    = "refs/tags/v${version}";
    sha256 = "sha256-esCWEzny/I+Ors6+upKlt4h13oN0bRLWN9OTKuSqdl8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = lib.optional stdenv.isDarwin cctools;
  buildInputs = [ ncurses libiconv libX11 libuuid ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=format-truncation";

  /*
  ** We patch out a very annoying 'feature' in ./configure, which
  ** tries to use 'git' to update submodules.
  **
  ** We have to also fix a few occurrences to tools with absolute
  ** paths in some helper scripts, otherwise the build will fail on
  ** NixOS or in any chroot build.
  */
  patchPhase = ''
    substituteInPlace ./configure \
      --replace "git submodule init && git submodule update || exit 1" "true"

    substituteInPlace ./workarea \
      --replace "/bin/ln" ln \
      --replace "/bin/cp" cp

    substituteInPlace ./makefiles/installsh \
      --replace "/usr/bin/true" "${coreutils}/bin/true"

    substituteInPlace zlib/configure \
      --replace "/usr/bin/libtool" libtool
  '';

  /*
  ** Don't use configureFlags, since that just implicitly appends
  ** everything onto a --prefix flag, which ./configure gets very angry
  ** about.
  **
  ** Also, carefully set a manual workarea argument, so that we
  ** can later easily find the machine type that we built Chez
  ** for.
  */
  configurePhase = ''
    ./configure --threads --installprefix=$out --installman=$out/share/man
  '';

  /*
  ** Clean up some of the examples from the build output.
  */
  postInstall = ''
    rm -rf $out/lib/csv${version}/examples
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    description  = "A powerful and incredibly fast R6RS Scheme compiler";
    homepage     = "https://cisco.github.io/ChezScheme/";
    license      = lib.licenses.asl20;
    maintainers  = with lib.maintainers; [ thoughtpolice ];
    platforms    = lib.platforms.unix;
    badPlatforms = [ "aarch64-linux" "aarch64-darwin" ];
  };
}
