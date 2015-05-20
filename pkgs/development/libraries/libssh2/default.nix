{ stdenv, fetchurl

# Optional Dependencies
, zlib ? null

# Crypto Dependencies
, openssl ? null, libgcrypt ? null
}:

let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  # Prefer openssl
  cryptoStr = if shouldUsePkg openssl != null then "openssl"
    else if shouldUsePkg libgcrypt != null then "libgcrypt"
      else "none";
  crypto = {
    openssl = openssl;
    libgcrypt = libgcrypt;
    none = null;
  }.${cryptoStr};

  optZlib = shouldUsePkg zlib;
in

assert crypto != null;

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "libssh2-1.5.0";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "1z6hfgak00yz0azx6lk6n688mywhdxx03j6sdf95p3w6ssnnn6c3";
  };

  buildInputs = [ crypto optZlib ];

  configureFlags = [
    (mkWith   (cryptoStr == "openssl")   "openssl"        null)
    (mkWith   (cryptoStr == "libgcrypt") "libgcrypt"      null)
    (mkWith   false                      "wicng"          null)
    (mkWith   optZlib                    "libz"           null)
    (mkEnable false                      "crypt-none"     null)
    (mkEnable false                      "mac-none"       null)
    (mkEnable true                       "gex-new"        null)
    (mkEnable false                      "debug"          null)
    (mkEnable false                      "examples-build" null)
  ];

  postInstall = optionalString (!stdenv.isDarwin) (''
    sed -i \
  '' + optionalString (optZlib != null) ''
      -e 's,\(-lz\),-L${optZlib}/lib \1,' \
  '' + optionalString (cryptoStr == "openssl") ''
      -e 's,\(-lssl\|-lcrypto\),-L${openssl}/lib \1,' \
  '' + optionalString (cryptoStr == "libgcrypt") ''
      -e 's,\(-lgcrypt\),-L${libgcrypt}/lib \1,' \
  '' + ''
      $out/lib/libssh2.la
  '');

  meta = {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = http://www.libssh2.org;
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ urkud wkennington ];
  };
}
