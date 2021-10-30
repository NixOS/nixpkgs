{ lib, stdenv
, fetchFromGitHub
, writeScript
, cmake
, pkg-config
, numactl
}:

stdenv.mkDerivation rec {
  pname = "rocm-thunk";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCT-Thunk-Interface";
    rev = "rocm-${version}";
    hash = "sha256-jpwFL4UbEnWkw1AiM4U1s1t7GiqzBeOwa55VpnOG2Dk=";
  };

  preConfigure = ''
    export cmakeFlags="$cmakeFlags "
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ numactl ];

  postInstall = ''
    cp -r $src/include $out
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/RadeonOpenCompute/ROCT-Thunk-Interface/tags" | jq '.[].name | split("-") | .[1] | select( . != null )' --raw-output | sort -n | tail -1)"
    update-source-version rocm-thunk "$version"
  '';

  meta = with lib; {
    description = "Radeon open compute thunk interface";
    homepage = "https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface";
    license = with licenses; [ bsd2 mit ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
