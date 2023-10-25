{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fleng";
  version = "14";

  src = fetchurl {
    url = "http://www.call-with-current-continuation.org/fleng/fleng-${finalAttrs.version}.tgz";
    hash = "sha256-Js9bllX/399t9oeiRrqJNUFyYJwJVb/xSzwrcMrdi08=";
  };

  doCheck = true;

  meta = {
    homepage = "http://www.call-with-current-continuation.org/fleng/fleng.html";
    description = "A low level concurrent logic programming language descended from Prolog";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
# TODO: bootstrap
