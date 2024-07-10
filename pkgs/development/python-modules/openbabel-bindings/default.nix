{
  lib,
  openbabel,
  python,
  buildPythonPackage,
}:

buildPythonPackage rec {
  inherit (openbabel) pname version;

  src = "${openbabel}/lib/python${python.sourceVersion.major}.${python.sourceVersion.minor}/site-packages";

  nativeBuildInputs = [ openbabel ];

  # these env variables are used by the bindings to find libraries
  # they need to be included explicitly in your nix-shell for
  # some functionality to work (inparticular, pybel).
  # see https://openbabel.org/docs/dev/Installation/install.html
  BABEL_LIBDIR = "${openbabel}/lib/openbabel/3.1.0";
  LD_LIBRARY_PATH = "${openbabel}/lib";

  doCheck = false;
  pythonImportsCheck = [ "openbabel" ];

  meta = with lib; {
    homepage = "http://openbabel.org/wiki/Main_Page";
    description = "Python bindings for openbabel";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ danielbarter ];
  };
}
