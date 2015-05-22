{ stdenv, fetchurl, pkgconfig

# Optinal Dependencies
, openssl ? null, libev ? null, zlib ? null, jansson ? null, boost ? null
, libxml2 ? null, jemalloc ? null

# Extra argument
, prefix ? ""
}:

with stdenv;
with stdenv.lib;
let
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
  version = "0.7.14";

  # Don't use fetchFromGitHub since this needs a bootstrap curl
  src = fetchurl {
    url = "http://pub.wak.io/nixos/tarballs/nghttp2-${version}.tar.bz2";
    sha256 = "000d50yzyysbr9ldhvnbpzn35vplqm08dnmh55wc5zk273gy383f";
  };

  # Configure script searches for a symbol which does not exist in jemalloc on Darwin
  # Reported upstream in https://github.com/tatsuhiro-t/nghttp2/issues/233
  postPatch = if (stdenv.isDarwin && optJemalloc != null) then ''
    substituteInPlace configure --replace "malloc_stats_print" "je_malloc_stats_print"
  '' else null;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ optJansson optBoost optLibxml2 optJemalloc ]
    ++ optionals hasApp [ optOpenssl optLibev optZlib ];

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
  ];

  meta = {
    homepage = http://nghttp2.org/;
    description = "an implementation of HTTP/2 in C";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
