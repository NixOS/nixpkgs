{ buildPythonPackage
, cmake
, fetchFromGitHub
, gtest
, hydra-core
, lib
, nlohmann_json
, pybind11
, PyVirtualDisplay
, sfml
, substituteAll
}:

buildPythonPackage rec {
  pname = "nocturne";
  version = "unstable-2022-10-15";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = pname;
    rev = "ae0a4e361457caf6b7e397675cc86f46161405ed";
    hash = "sha256-pFVbl4m7qX1mJgleNabRboS9klDDsbzUa4PYL5+Jupc=";
  };

  # Simulate the git submodules but with nixpkgs dependencies
  postUnpack = ''
    rm -rf $sourceRoot/third_party/*
    ln -s ${nlohmann_json.src} $sourceRoot/third_party/json
    ln -s ${pybind11.src} $sourceRoot/third_party/pybind11
  '';

  patches = [
    (substituteAll {
      src = ./dependencies.patch;
      gtest_src = gtest.src;
    })
  ];

  nativeBuildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  buildInputs = [ sfml ];

  # hydra-core and PyVirtualDisplay are not declared as dependences but they are requirements
  propagatedBuildInputs = [ hydra-core PyVirtualDisplay ];

  # Test suite requires hydra-submitit-launcher which is not packaged as of 2022-01-02
  doCheck = false;

  pythonImportsCheck = [
    "nocturne"
  ];

  meta = with lib; {
    description = "A data-driven, fast driving simulator for multi-agent coordination under partial observability";
    homepage = "https://github.com/facebookresearch/nocturne";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
