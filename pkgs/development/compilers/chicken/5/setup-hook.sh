addChickenRepositoryPath() {
    addToSearchPathWithCustomDelimiter : CHICKEN_REPOSITORY_PATH "$1/lib/chicken/9/"
    addToSearchPathWithCustomDelimiter : CHICKEN_INCLUDE_PATH "$1/share/"
}

addEnvHooks "$targetOffset" addChickenRepositoryPath
