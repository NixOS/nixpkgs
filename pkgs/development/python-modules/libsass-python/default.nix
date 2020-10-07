{ stdenv, fetchFromGitHub, buildPythonPackage, libsass, six }:

buildPythonPackage rec {
  pname = "libsass-python";
  version = "0.20.1";

  SYSTEM_SASS = 1;

  src = fetchFromGitHub {
    owner = "sass";
    repo = "libsass-python";
    rev = "${version}";
    sha256 = "1r0kgl7i6nnhgjl44sjw57k08gh2qr7l8slqih550dyxbf1akbxh";
  };

  propagatedBuildInputs = [
    libsass six
  ];

  meta = with stdenv.lib; {
    description = "Sass for Python: A straightforward binding of libsass for Python.";
    homepage    = "https://sass.github.io/libsass-python/";
    license     = licenses.mit;
    maintainers = with maintainers; [ alexbakker ];
  };
}
