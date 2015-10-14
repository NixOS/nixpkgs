{ makeSetupHook, makeQtWrapper }:

makeSetupHook { deps = [ makeQtWrapper ]; } ./make-kde-wrapper.sh
