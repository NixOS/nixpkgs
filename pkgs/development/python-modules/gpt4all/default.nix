{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
, tqdm
}:

buildPythonPackage rec {
  pname = "gpt4all";
  version = "1.0.8";
  format = "wheel";

  disabled = pythonOlder "3.8";

  src = let
    system = {
      "x86_64-linux" = {
        name = "x86_64";
        hash = "sha256-lrX44Tl4TZzhGuosttOdeGaUPXy1dJF69I7KTMyzGhI=";
      };
    }.${stdenv.system} or (throw "Unsupported system");
  in fetchPypi {
    inherit pname format version;
    inherit (system) hash;
    platform = "manylinux1_${system.name}";
    python = "py3";
  };

  nativeBuildInputs = [
    requests
    tqdm
  ];

  meta = with lib; {
    description = "Python bindings for GPT4All";
    homepage = "https://gpt4all.io";
    license = licenses.zpl21;
    maintainers = with maintainers; [ bbigras ];
  };
}
