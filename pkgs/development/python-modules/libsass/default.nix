{ lib, buildPythonPackage, fetchFromGitHub, libsass, six, pytest, werkzeug }:

buildPythonPackage rec {
  pname = "libsass";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "sass";
    repo = "libsass-python";
    rev = version;
    sha256 = "1r0kgl7i6nnhgjl44sjw57k08gh2qr7l8slqih550dyxbf1akbxh";
  };

  buildInputs = [ libsass ];

  propagatedBuildInputs = [ six ];

  preBuild = ''
    export SYSTEM_SASS=true;
  '';

  checkInputs = [
    pytest
    werkzeug
  ];

  checkPhase = ''
    pytest sasstests.py
  '';

  meta = with lib; {
    description = "A straightforward binding of libsass for Python. Compile Sass/SCSS in Python with no Ruby stack at all!";
    homepage = "https://sass.github.io/libsass-python/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
