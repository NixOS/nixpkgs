addChickenRepositoryPath() {
    addToSearchPathWithCustomDelimiter : CHICKEN_REPOSITORY_PATH "$1/lib/chicken/12"
    addToSearchPathWithCustomDelimiter : CHICKEN_INCLUDE_PATH "$1/share"
}

addEnvHooks "$targetOffset" addChickenRepositoryPath
