# Tell the pybind11 CMake module where to find host platform Python. This is
# required when cross-compiling.
prependToVar cmakeFlags \
  '-DPYBIND11_PYTHONLIBS_OVERWRITE=OFF' \
  '-DPYTHON_EXECUTABLE=@pythonInterpreter@' \
  '-DPYTHON_INCLUDE_DIR=@pythonIncludeDir@' \
  '-DPYTHON_SITE_PACKAGES=@pythonSitePackages@' \
  '-DPython_INCLUDE_DIR=@pythonIncludeDir@' \
  '-DPython3_INCLUDE_DIR=@pythonIncludeDir@' \
  '-DPython_EXECUTABLE=@pythonInterpreter@' \
  '-DPython3_EXECUTABLE=@pythonInterpreter@'
