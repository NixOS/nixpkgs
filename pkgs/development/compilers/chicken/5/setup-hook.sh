addChickenRepositoryPath() {
    addToSearchPathWithCustomDelimiter : CHICKEN_REPOSITORY_PATH "$1/lib/chicken/11"
    addToSearchPathWithCustomDelimiter : CHICKEN_INCLUDE_PATH "$1/share"
}

addEnvHooks "$targetOffset" addChickenRepositoryPath
