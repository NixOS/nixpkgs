{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  digiham,
  pycsdr,
  codecserver,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydigiham";
  version = "0.6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jketterl";
    repo = "pydigiham";
    rev = finalAttrs.version;
    hash = "sha256-QenoMyVFs8MEDPoMV6TT6XfzktfN/gAMIHR0Scq11wk=";
  };

  propagatedBuildInputs = [ digiham ];
  buildInputs = [
    codecserver
    pycsdr
  ];
  # make pycsdr header files available
  preBuild = ''
    ln -s ${pycsdr}/include/${python.libPrefix}/pycsdr src/pycsdr
  '';

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "digiham" ];

  meta = {
    homepage = "https://github.com/jketterl/pydigiham";
    description = "Bindings for the csdr library";
    license = lib.licenses.gpl3Only;
  };
})
