{ lib, buildPythonPackage, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "boolean.py";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "bastikr";
    repo = "boolean.py";
    rev = "v${version}";
    sha256 = "1q9ji2jq07qr6vgp9yv6y8lx6h0zyi07fqjga3yi3vpfk46h2jn1";
  };

  meta = with lib; {
    homepage = "https://github.com/bastikr/boolean.py";
    description = "Implements boolean algebra in one module";
    license = licenses.bsd2;
  };

}
