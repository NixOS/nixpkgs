{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
  numpy,
  pillow,
  sty,
}:

buildPythonPackage (finalAttrs: {
  pname = "picharsso";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-602LGh/mknh00CNi7rJDb4a/m0/uAswKx2not2HBJ28=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    click
    numpy
    pillow
    sty
  ];

  doCheck = false;

  meta = with lib; {
    description = "A utility for converting images to text art";
    homepage = "https://github.com/kelvindecosta/picharsso";
    license = licenses.mit;
    maintainers = with maintainers; [ alikaansun ];
  };
})
