{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  libasyncns,
  pkg-config,
}:

buildPythonPackage rec {
  pname = "libasyncns-python";
  version = "0.7.1";
  format = "setuptools";

  src = fetchurl {
    url = "https://launchpad.net/libasyncns-python/trunk/${version}/+download/libasyncns-python-${version}.tar.bz2";
    hash = "sha256-D/dX+Nm/HwcFSretLQNDTeTPprnWy0u6KQcnKFY4lOA=";
  };

  patches = [ ./libasyncns-fix-res-consts.patch ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace resquery.c \
      --replace '<arpa/nameser.h>' '<arpa/nameser_compat.h>'
  '';

  buildInputs = [ libasyncns ];
  nativeBuildInputs = [ pkg-config ];
  doCheck = false; # requires network access

  pythonImportsCheck = [ "libasyncns" ];

  meta = {
    description = "Libasyncns-python is a python binding for the asynchronous name service query library";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.mic92 ];
    homepage = "https://launchpad.net/libasyncns-python";
  };
}
