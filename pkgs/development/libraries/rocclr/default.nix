{ lib, stdenv
, fetchFromGitHub
, writeScript
, rocm-comgr
}:

stdenv.mkDerivation rec {
  pname = "rocclr";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "ROCclr";
    rev = "rocm-${version}";
    hash = "sha256-x6XwYxgiCoy6Q7gIevSTEWgUQ0aEjPFhKSqMqQahHig=";
  };

  prePatch = ''
    substituteInPlace device/comgrctx.cpp \
      --replace "libamd_comgr.so" "${rocm-comgr}/lib/libamd_comgr.so"
  '';

  buildPhase = "";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out/

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl -sL "https://api.github.com/repos/ROCm-Developer-Tools/ROCclr/tags" | jq '.[].name | split("-") | .[1] | select( . != null )' --raw-output | sort -n | tail -1)"
    update-source-version rocclr "$version"
  '';

  meta = with lib; {
    description = "Source package of the Radeon Open Compute common language runtime";
    homepage = "https://github.com/ROCm-Developer-Tools/ROCclr";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
    # rocclr seems to have some AArch64 ifdefs, but does not seem
    # to be supported yet by the build infrastructure. Recheck in
    # the future.
    platforms = [ "x86_64-linux" ];
  };
}
