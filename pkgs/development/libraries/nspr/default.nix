{stdenv, fetchurl}:

let version = "4.8"; in

stdenv.mkDerivation {
  name = "nspr-${version}";

  src = fetchurl {
    url = "http://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v${version}/src/nspr-${version}.tar.gz";
    sha256 = "1znvc7fb4f6318kbn1w86p134r4cslij25sg7kcspfx746m89pm2";
  };

  preConfigure = "cd mozilla/nsprpub";

  configureFlags = "--enable-optimize --disable-debug";

  postInstall =
    ''
      find $out -name "*.a" | xargs rm
    '';
    
  meta = {
    homepage = http://www.mozilla.org/projects/nspr/;
    description = "Netscape Portable Runtime, a platform-neutral API for system-level and libc-like functions";
  };
}
