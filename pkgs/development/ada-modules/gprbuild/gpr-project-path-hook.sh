addAdaObjectsPath() {
    local role_post
    getHostRoleEnvHook

    addToSearchPath "GPR_PROJECT_PATH${role_post}" "$1/share/gpr"
}

addEnvHooks "$targetOffset" addAdaObjectsPath
