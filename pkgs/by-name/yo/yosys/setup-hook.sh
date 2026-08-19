addYosysPluginPath() {
  addToSearchPath NIX_YOSYS_PLUGIN_DIRS "$1/share/yosys/plugins"
}

addEnvHooks "$targetOffset" addYosysPluginPath
