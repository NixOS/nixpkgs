{ lib
, buildPythonPackage
, fetchPypi
, fetchurl
}:

buildPythonPackage rec {
  pname = "intelhex";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "009d8511e0d50639230c39af9607deee771cf026f67ef7507a8c3fd4fa927832";
  };

  patches = [
    (fetchurl {
      url = https://github.com/bialix/intelhex/commit/1597874d2bce3e5cefa1c0bf10cf2e98b6181337.patch;
      sha256 = "19a5b535brgpsm1y9b37i4465k0z7skxijw44ykv7kpirh8mzxaq";
    })
  ];

  meta = {
    homepage = https://github.com/bialix/intelhex;
    description = "Python library for Intel HEX files manipulations";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pjones ];
  };
}
