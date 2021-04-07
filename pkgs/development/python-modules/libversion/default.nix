{ lib, buildPythonPackage, fetchPypi, pkg-config, libversion, pythonOlder }:

buildPythonPackage rec {
  pname = "libversion";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf9ef702d0bc750f0ad44a2cffe8ebd83cd356b92cc25f767846509f84ea7e73";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libversion ];

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = "https://github.com/repology/py-libversion";
    description = "Python bindings for libversion, which provides fast, powerful and correct generic version string comparison algorithm";
    license = licenses.mit;
    maintainers = [ maintainers.ryantm ];
  };
}
