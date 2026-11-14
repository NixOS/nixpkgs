{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  passagemath-symbolics,
  passagemath-standard-no-symbolics,
  passagemath-maxima,
  passagemath-runtimes,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-standard";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
  ];
  dependencies = [
    passagemath-standard-no-symbolics
    passagemath-symbolics
    passagemath-maxima
    passagemath-runtimes
  ];

  src = fetchPypi {
    pname = "passagemath_standard";
    inherit version;
    hash = "sha256-a3/gOoiXvp9a0hW4uOD8noq99n6WUn/LbbBI8AjlFA4=";
  };

  meta = {
    description = "passagemath: Standard Python Library";
    longDescription = ''
      `passagemath-standard` is a metapackage that provides all standard
      components of the Sage library.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
