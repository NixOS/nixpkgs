{ stdenv, buildPythonPackage, fetchPypi, pkgconfig, libversion, pythonOlder }:

buildPythonPackage rec {
  pname = "libversion";
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xp0wv4s1537s0iqa1ih3kfh1p70s7d1fkwhvrnbj8m98yjij84q";
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
