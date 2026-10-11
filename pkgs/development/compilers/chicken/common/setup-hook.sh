addChickenRepositoryPath() {
    addToSearchPathWithCustomDelimiter : CHICKEN_REPOSITORY_PATH "$1/lib/chicken/@binaryVersion@"
    addToSearchPathWithCustomDelimiter : CHICKEN_INCLUDE_PATH "$1/share"
}

addEnvHooks "$targetOffset" addChickenRepositoryPath
