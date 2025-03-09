addChickenRepositoryPath() {
    appendToSearchPathWithCustomDelimiter : CHICKEN_REPOSITORY_PATH "$1/lib/chicken/11"
    appendToSearchPathWithCustomDelimiter : CHICKEN_INCLUDE_PATH "$1/share"
}

addEnvHooks "$targetOffset" addChickenRepositoryPath
