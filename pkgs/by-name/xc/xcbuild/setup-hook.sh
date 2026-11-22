xcbuildBuildPhase() {
    export DSTROOT=$out

    runHook preBuild

    local flagsArray=()
    concatTo flagsArray xcbuildFlags

    echoCmd 'running xcodebuild' "${flagsArray[@]}"

    xcodebuild SYMROOT=$PWD/Products OBJROOT=$PWD/Intermediates "${flagsArray[@]}" build

    runHook postBuild
}

xcbuildInstallPhase () {
    runHook preInstall

    # not implemented
    # xcodebuild install

    runHook postInstall
}

buildPhase=xcbuildBuildPhase
if [ -z "${installPhase-}" ]; then
    installPhase=xcbuildInstallPhase
fi

# if [ -d "*.xcodeproj" ]; then
#     buildPhase=xcbuildPhase
# fi
