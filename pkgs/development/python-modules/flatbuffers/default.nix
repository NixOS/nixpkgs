{ lib
, buildPythonPackage
, flatbuffers
}:

buildPythonPackage rec {
  inherit (flatbuffers) pname version src;

<<<<<<< HEAD
  sourceRoot = "${src.name}/python";

  # flatbuffers needs VERSION environment variable for setting the correct
  # version, otherwise it uses the current date.
  VERSION = version;
=======
  sourceRoot = "source/python";

  # flatbuffers needs VERSION environment variable for setting the correct
  # version, otherwise it uses the current date.
  VERSION = "${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [ "flatbuffers" ];

  meta = flatbuffers.meta // {
    description = "Python runtime library for use with the Flatbuffers serialization format";
    maintainers = with lib.maintainers; [ wulfsta ];
    mainProgram = "flatc";
  };
}
