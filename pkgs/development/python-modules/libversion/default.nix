{ stdenv, buildPythonPackage, fetchPypi, pkgconfig, libversion, pythonOlder }:

buildPythonPackage rec {
  pname = "libversion";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "040adjp5xjr4vwz3x2mspkymlcmljvqvacr88aw0jijq1h6fm59c";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libversion ];

  disabled = pythonOlder "3.6";

  meta = with stdenv.lib; {
    homepage = https://github.com/repology/py-libversion;
    description = "Python bindings for libversion, which provides fast, powerful and correct generic version string comparison algorithm";
    license = licenses.mit;
    maintainers = [ maintainers.ryantm ];
  };
}
