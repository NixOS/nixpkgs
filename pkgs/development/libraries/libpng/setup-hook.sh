libpngConfigToPATH() {
    PATH="@dev@/bin:$PATH"
}
postHooks+=(libpngConfigToPATH)
