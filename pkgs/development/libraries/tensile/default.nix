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
  repoVersion = "4.34.0";
  rocmVersion = "5.3.3";
  version = "${repoVersion}-${rocmVersion}";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "Tensile";
    rev = "rocm-${rocmVersion}";
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
    json="$(curl -sL "https://api.github.com/repos/ROCmSoftwarePlatform/Tensile/releases?per_page=1")"
    repoVersion="$(echo "$json" | jq '.[0].name | split(" ") | .[1]' --raw-output)"
    rocmVersion="$(echo "$json" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version tensile "$repoVersion" --ignore-same-hash --version-key=repoVersion
    update-source-version tensile "$rocmVersion" --ignore-same-hash --version-key=rocmVersion
  '';

  meta = with lib; {
    description = "GEMMs and tensor contractions";
    homepage = "https://github.com/ROCmSoftwarePlatform/Tensile";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
  };
}
