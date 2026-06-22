teensyCMakeMacrosEnvHook() {
  cmakeFlagsArray+=(-DCMAKE_MODULE_PATH=@out@/lib/cmake)
}

addEnvHooks "$targetOffset" teensyCMakeMacrosEnvHook
