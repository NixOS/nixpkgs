addChickenRepositoryPath() {
    addToSearchPathWithCustomDelimiter : CHICKEN_REPOSITORY_EXTRA "$1/lib/chicken/8/"
    export CHICKEN_INCLUDE_PATH="$1/share${CHICKEN_INCLUDE_PATH:+;$CHICKEN_INCLUDE_PATH}"
}

addEnvHooks "$targetOffset" addChickenRepositoryPath
