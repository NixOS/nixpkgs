{ lib
, stdenv
, fetchurl
, fetchpatch
, perl
, CoreServices
, ApplicationServices
}:

stdenv.mkDerivation rec {
  pname = "moarvm";
  version = "2022.07";

  src = fetchurl {
    url = "https://moarvm.org/releases/MoarVM-${version}.tar.gz";
    hash = "sha256-M37wTRb4JvmUZcZTuSAGAo/iIL5o09z9BylhL09rW0Y=";
  };

  patches = [
    (fetchpatch {
      name = "mimalloc-older-macos-fixes.patch";
      url = "https://github.com/microsoft/mimalloc/commit/40e0507a5959ee218f308d33aec212c3ebeef3bb.patch";
      stripLen = 1;
      extraPrefix = "3rdparty/mimalloc/";
      sha256 = "1gcbn1850vy7xzalhn9ffnsg6x1ywi3fmnxvnal3m6lmb4kz5kb1";
    })
  ];

  postPatch = ''
    patchShebangs .
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Configure.pl \
      --replace '`/usr/bin/arch`' '"${stdenv.hostPlatform.darwinArch}"' \
      --replace '/usr/bin/arch' "$(type -P true)" \
      --replace '/usr/' '/nope/'
    substituteInPlace 3rdparty/dyncall/configure \
      --replace '`sw_vers -productVersion`' '"$MACOSX_DEPLOYMENT_TARGET"'
  '';

  buildInputs = [ perl ] ++ lib.optionals stdenv.isDarwin [ CoreServices ApplicationServices ];
  doCheck = false; # MoarVM does not come with its own test suite

  configureScript = "${perl}/bin/perl ./Configure.pl";

  meta = with lib; {
    description = "VM with adaptive optimization and JIT compilation, built for Rakudo";
    homepage = "https://moarvm.org";
    license = licenses.artistic2;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
    mainProgram = "moar";
    platforms = platforms.unix;
  };
}
