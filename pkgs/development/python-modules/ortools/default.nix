{
  lib,
  buildPythonPackage,
  lndir,
  or-tools,
  immutabledict,
  numpy,
  pandas,
  protobuf,
}:

buildPythonPackage {
  pname = "ortools";
  inherit (or-tools) version;
  format = "other";

  src = or-tools.python;

  dontBuild = true;

  nativeBuildInputs = [ lndir ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    lndir -silent $src $out
    runHook postInstall
  '';

  propagatedBuildInputs = [
    immutabledict
    numpy
    pandas
    protobuf
  ];

  pythonImportsCheck = [
    "ortools"
    "ortools.sat.python.cp_model"
  ];

  meta = or-tools.meta // {
    description = "Python bindings for Google's or-tools";
  };
}
