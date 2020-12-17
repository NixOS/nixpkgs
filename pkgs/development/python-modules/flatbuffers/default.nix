{ stdenv
, buildPythonPackage
, flatbuffers
}:

buildPythonPackage rec {
  inherit (flatbuffers) pname version src;

  sourceRoot = "source/python";

  pythonImportsCheck = [ "flatbuffers" ];

  meta = flatbuffers.meta // {
    description = "Python runtime library for use with the Flatbuffers serialization format";
    maintainers = with stdenv.lib.maintainers; [ wulfsta ];
  };
}
