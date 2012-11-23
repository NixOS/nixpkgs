source $stdenv/setup

# do not allow distutils to make downloads, whatever install command is used
export PYTHONPATH="${setuptools}/lib/${python.libPrefix}:$PYTHONPATH"
export PYTHONPATH="${offlineDistutils}/lib/${python.libPrefix}:$PYTHONPATH"

# enable pth files for dependencies
export PYTHONPATH="${site}/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

genericBuild
