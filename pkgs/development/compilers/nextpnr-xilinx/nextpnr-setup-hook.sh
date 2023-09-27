addNextpnrPaths() {
  addToSearchPath NEXTPNR_XILINX_DIR "$1/usr/share/nextpnr"
}

addEnvHooks "$targetOffset" addNextpnrPaths
