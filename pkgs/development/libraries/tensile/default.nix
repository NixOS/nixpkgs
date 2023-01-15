{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, buildPythonPackage
, pyyaml
, msgpack
, pandas
}:

buildPythonPackage rec {
  pname = "tensile";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "Tensile";
    rev = "rocm-${version}";
    hash = "sha256-W6yr6mptfsiJSSzPCImgqI1EmsUv+l99SjqkoZsOjag=";
  };

  buildInputs = [
    pyyaml
    msgpack
    pandas
  ];

  passthru.updateScript = rocmUpdateScript {
    name = pname;
    owner = src.owner;
    repo = src.repo;
  };

  meta = with lib; {
    description = "GEMMs and tensor contractions";
    homepage = "https://github.com/ROCmSoftwarePlatform/Tensile";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = versions.minor version != versions.minor stdenv.cc.version;
  };
}
