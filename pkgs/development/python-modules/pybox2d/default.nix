{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  swig,
}:

buildPythonPackage rec {
  pname = "pybox2d";
  version = "2.3.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pybox2d";
    repo = "pybox2d";
    rev = "refs/tags/${version}";
    hash = "sha256-yjLFvsg8GQLxjN1vtZM9zl+kAmD4+eS/vzRkpj0SCjY=";
  };

  nativeBuildInputs = [ swig ];

  # We need to build the package explicitly a first time so that the library/Box2D/Box2D.py file
  # gets generated.
  # After that, the default behavior will succeed at installing the package.
  preBuild = ''
    python setup.py build
  '';

  pythonImportsCheck = [
    "Box2D"
    "Box2D._Box2D"
  ];

  # Tests need to start GUI windows.
  doCheck = false;

  meta = with lib; {
    description = "2D Game Physics for Python";
    homepage = "https://github.com/pybox2d/pybox2d";
    license = licenses.zlib;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
