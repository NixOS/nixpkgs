{ lib, buildPythonPackage, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "boolean.py";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "bastikr";
    repo = "boolean.py";
    rev = "v${version}";
    sha256 = "1wc89y73va58cj7dsx6c199zpxsy9q53dsffsdj6zmc90inqz6qs";
  };

  meta = with lib; {
    homepage = "https://github.com/bastikr/boolean.py";
    description = "Implements boolean algebra in one module";
    license = licenses.bsd2;
  };

}
