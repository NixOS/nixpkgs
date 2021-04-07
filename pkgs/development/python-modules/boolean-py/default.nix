{ lib, buildPythonPackage, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "boolean.py";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "bastikr";
    repo = "boolean.py";
    rev = "v${version}";
    sha256 = "02jznrfrihhk69ai1vnh26s3rshl4kfc2id7li6xccavc2ws5y3b";
  };

  meta = with lib; {
    homepage = "https://github.com/bastikr/boolean.py";
    description = "Implements boolean algebra in one module";
    license = licenses.bsd2;
  };

}
