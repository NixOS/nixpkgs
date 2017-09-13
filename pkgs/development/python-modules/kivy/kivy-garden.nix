# The sole reason for this package is that it is a (questionable) dependency of Kivy
{ buildPythonPackage, fetchPypi, maintainers, platforms, licenses, pkgs, self }:

buildPythonPackage rec {
  pname = "kivy-garden";
  version = "0.1.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wkcpr2zc1q5jb0bi7v2dgc0vs5h1y7j42mviyh764j2i0kz8mn2";
  };

  buildInputs = with self; [ ];
  propagatedBuildInputs = with self; [ requests ];

  meta = {
    description = "The kivy garden installation script, split into its own package for convenient use in buildozer.";

    homepage    = "https://pypi.python.org/pypi/kivy-garden";
    license     = licenses.mit;
    maintainers = with maintainers; [ vanschelven ];
    platforms   = platforms.unix;  # Can only test linux; in principle other platforms are supported
  };
}
