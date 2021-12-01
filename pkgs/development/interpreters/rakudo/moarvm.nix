{ lib, stdenv, fetchurl, perl
, CoreServices, ApplicationServices }:

stdenv.mkDerivation rec {
  pname = "moarvm";
  version = "2021.10";

  src = fetchurl {
    url = "https://moarvm.org/releases/MoarVM-${version}.tar.gz";
    sha256 = "sha256-fzSHpw6Ld74OTi8SsUxJ9qAdA3jglAyGlYyQFsSVrXU=";
   };

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
    homepage    = "https://moarvm.org";
    license     = licenses.artistic2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}
