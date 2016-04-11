{ stdenv, fetchurl, pkgconfig

# Optinal Dependencies
, openssl ? null, libev ? null, zlib ? null, jansson ? null, boost ? null
, libxml2 ? null, jemalloc ? null

# Extra argument
, prefix ? ""
}:

let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  isLib = prefix == "lib";

  optOpenssl = if isLib then null else shouldUsePkg openssl;
  optLibev = if isLib then null else shouldUsePkg libev;
  optZlib = if isLib then null else shouldUsePkg zlib;

  hasApp = optOpenssl != null && optLibev != null && optZlib != null;

  optJansson = if isLib then null else shouldUsePkg jansson;
  #optBoost = if isLib then null else shouldUsePkg boost;
  optBoost = null; # Currently detection is broken
  optLibxml2 = if !hasApp then null else shouldUsePkg libxml2;
  optJemalloc = if !hasApp then null else shouldUsePkg jemalloc;
in
stdenv.mkDerivation rec {
  name = "${prefix}nghttp2-${version}";
  version = "1.8.0";

  # Don't use fetchFromGitHub since this needs a bootstrap curl
  src = fetchurl {
    url = "https://github.com/nghttp2/nghttp2/releases/download/v${version}/nghttp2-${version}.tar.bz2";
    sha256 = "10xz3s624w208pr9xgm4ammc8bc5mi17vy4357hjfd5vmmp5m8b0";
  };

  # Configure script searches for a symbol which does not exist in jemalloc on Darwin
  # Reported upstream in https://github.com/tatsuhiro-t/nghttp2/issues/233
  postPatch = if (stdenv.isDarwin && optJemalloc != null) then ''
    substituteInPlace configure --replace "malloc_stats_print" "je_malloc_stats_print"
  '' else null;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ optJansson optBoost optLibxml2 optJemalloc ]
    ++ stdenv.lib.optionals hasApp [ optOpenssl optLibev optZlib ];

  configureFlags = [
    (mkEnable false                 "werror"          null)
    (mkEnable false                 "debug"           null)
    (mkEnable true                  "threads"         null)
    (mkEnable hasApp                "app"             null)
    (mkEnable (optJansson != null)  "hpack-tools"     null)
    (mkEnable (optBoost != null)    "asio-lib"        null)
    (mkEnable false                 "examples"        null)
    (mkEnable false                 "python-bindings" null)
    (mkEnable false                 "failmalloc"      null)
    (mkWith   (optLibxml2 != null)  "libxml2"         null)
    (mkWith   (optJemalloc != null) "jemalloc"        null)
    (mkWith   false                 "spdylay"         null)
    (mkWith   false                 "cython"          null)
    (mkWith   false                 "mruby"           null)
  ];

  meta = with stdenv.lib; {
    homepage = http://nghttp2.org/;
    description = "an implementation of HTTP/2 in C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
