addChickenRepositoryPath() {
    addToSearchPathWithCustomDelimiter : CHICKEN_REPOSITORY_PATH "$HOME/lib/chicken/11/"
    addToSearchPathWithCustomDelimiter : CHICKEN_INCLUDE_PATH "$1/share/"
}

addEnvHooks "$targetOffset" addChickenRepositoryPath
