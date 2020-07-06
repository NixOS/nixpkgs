{ stdenv, buildPythonPackage, fetchPypi, pkgconfig, libversion, pythonOlder }:

buildPythonPackage rec {
  pname = "libversion";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h8x9hglrqi03f461lhw3wwz23zs84dgw7hx4laxcmyrgvyzvcq1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libversion ];

  disabled = pythonOlder "3.6";

  meta = with stdenv.lib; {
    homepage = "https://github.com/repology/py-libversion";
    description = "Python bindings for libversion, which provides fast, powerful and correct generic version string comparison algorithm";
    license = licenses.mit;
    maintainers = [ maintainers.ryantm ];
  };
}
