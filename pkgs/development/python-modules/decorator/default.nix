{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "4.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "54c38050039232e1db4ad7375cfce6748d7b41c29e95a081c8a6d2c30364a2ce";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/micheles/decorator/commit/3265f2755d16c0a3dfc9f1feee39722ddc11ee80.patch;
      sha256 = "1q5nmff30vccqq5swf2ivm8cn7x3lhz8c9qpj0zddgs2y7fw8syz";
    })
  ];

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/decorator;
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
