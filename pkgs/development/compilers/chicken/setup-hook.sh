addChickenRepositoryPath() {
    prependToSearchPathWithCustomDelimiter ':' CHICKEN_REPOSITORY_EXTRA "$1/lib/chicken/8/"
    prependToSearchPathWithCustomDelimiter ';' CHICKEN_INCLUDE_PATH "$1/share/"
}

envHooks+=(addChickenRepositoryPath)
