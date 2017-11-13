@name@ () {
  prependToSearchPath LHAPDF_DATA_PATH "@out@"
}

postHooks+=(@name@)
