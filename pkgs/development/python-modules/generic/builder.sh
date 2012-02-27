source $stdenv/setup

# move checkPhase from after buildPhase to after fixupPhase
phases="$prePhases unpackPhase patchPhase $preConfigurePhases \
        configurePhase $preBuildPhases buildPhase \
        $preInstallPhases installPhase fixupPhase checkPhase \
        $preDistPhases distPhase $postPhases";

genericBuild
