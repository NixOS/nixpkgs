{ lib
, stdenv
, fetchFromGitHub
, writeScript
, buildPythonPackage
, pyyaml
, msgpack
, pandas
}:

buildPythonPackage rec {
  pname = "tensile";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "Tensile";
    rev = "rocm-${version}";
    hash = "sha256-6A7REYdIw/ZmjrJh7B+wCXZMleh4bf04TFpRItPtctA=";
  };

  buildInputs = [
    pyyaml
    msgpack
    pandas
  ];

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} \
      -sL "https://api.github.com/repos/ROCmSoftwarePlatform/Tensile/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version tensile "$version" --ignore-same-hash
  '';

  meta = with lib; {
    description = "GEMMs and tensor contractions";
    homepage = "https://github.com/ROCmSoftwarePlatform/Tensile";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
  };
}
