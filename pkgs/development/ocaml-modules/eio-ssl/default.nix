{
  lib,
  buildDunePackage,
  fetchurl,
  fetchpatch,
  eio,
  ssl,
}:

buildDunePackage (finalAttrs: {
  pname = "eio-ssl";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/anmonteiro/eio-ssl/releases/download/${finalAttrs.version}/eio-ssl-${finalAttrs.version}.tbz";
    hash = "sha256-m4CiUQtXVSMfLthbDsAftpiOsr24I5IGiU1vv7Rz8go=";
  };

  patches =
    # Compatibility with eio 1.4
    lib.optional (lib.versionAtLeast eio.version "1.4") (fetchpatch {
      url = "https://github.com/anmonteiro/eio-ssl/commit/8cf6bccd2c272445d1dc93eb1d65e965f95646d4.patch";
      hash = "sha256-NnwWDhr5H70EFVK+1/qbIA+srJHjxSvtWvakBXnrZMI=";
    });

  propagatedBuildInputs = [
    eio
    ssl
  ];

  meta = {
    homepage = "https://github.com/anmonteiro/eio-ssl";
    description = "OpenSSL binding to EIO";
    license = lib.licenses.lgpl21;
  };
})
