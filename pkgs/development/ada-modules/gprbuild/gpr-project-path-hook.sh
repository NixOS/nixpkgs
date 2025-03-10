addAdaObjectsPath() {
    local role_post
    getHostRoleEnvHook

    appendToSearchPath "GPR_PROJECT_PATH${role_post}" "$1/share/gpr"
}

addEnvHooks "$targetOffset" addAdaObjectsPath
