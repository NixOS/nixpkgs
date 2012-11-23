source $stdenv/setup

# do not allow distutils to make downloads, whatever install command is used
export PYTHONPATH="${offlineDistutils}/lib/${python.libPrefix}:$PYTHONPATH"

genericBuild
