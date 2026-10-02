addChickenRepositoryPath() {
    addToSearchPathWithCustomDelimiter : CHICKEN_REPOSITORY_PATH "$1/lib/chicken/@binaryVersion@"
    addToSearchPathWithCustomDelimiter : CHICKEN_INCLUDE_PATH "$1/share"
}

# The eggs that compiled code runs with. They differ from the ones above only
# when cross-compiling, and serve for linking and wrapping programs.
addChickenTargetRepositoryPath() {
    addToSearchPathWithCustomDelimiter : NIX_CHICKEN_TARGET_REPOSITORY_PATH "$1/lib/chicken/@binaryVersion@"
    addToSearchPathWithCustomDelimiter : NIX_CHICKEN_TARGET_INCLUDE_PATH "$1/share"
}

addEnvHooks "@compileTimeOffset@" addChickenRepositoryPath
addEnvHooks "$targetOffset" addChickenTargetRepositoryPath
