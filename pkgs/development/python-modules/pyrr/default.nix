{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  multipledispatch,
  numpy,
}:

buildPythonPackage {
  pname = "pyrr";
  version = "unstable-2022-07-22";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "adamlwgriffiths";
    repo = "Pyrr";
    rev = "f6c8698c48a75f3fb7ad0d47d0ce80a04f87ba2f";
    hash = "sha256-u9O52MQskZRzw0rBH6uPdXdikWLJe7wyBZGNKIFA4BA=";
  };

  propagatedBuildInputs = [
    multipledispatch
    numpy
  ];

  meta = {
    description = "3D mathematical functions using NumPy";
    homepage = "https://github.com/adamlwgriffiths/Pyrr/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ c0deaddict ];
  };
}
