{ stdenv, buildPythonPackage, fetchPypi, pkgconfig, libversion, pythonOlder }:

buildPythonPackage rec {
  pname = "libversion";
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ax1bq5hrbs2pq2krya83yj1s5cm33pcpwalnc15cgj73kmhb5fn";
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
