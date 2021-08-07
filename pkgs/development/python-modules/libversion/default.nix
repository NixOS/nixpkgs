{ lib, buildPythonPackage, fetchPypi, pkg-config, libversion, pythonOlder }:

buildPythonPackage rec {
  pname = "libversion";
  version = "1.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e6e903cc6307c3eda90401373eb81bfd0dd2dc93772ddab3d23705bed0c6f6e9";
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
