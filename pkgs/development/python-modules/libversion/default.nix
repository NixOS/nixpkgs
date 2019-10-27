{ stdenv, buildPythonPackage, fetchPypi, pkgconfig, libversion, pythonOlder }:

buildPythonPackage rec {
  pname = "libversion";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p3snjlsg11vhba8h286h19kn6azlxbywg9f6rdhj8sfraccqlmk";
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
