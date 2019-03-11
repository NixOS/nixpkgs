{ lib
, buildPythonPackage
, numba
, ndtypes
, xnd
, libndtypes
, libxnd
, libgumath
, isPy27
}:

buildPythonPackage {
  pname = "gumath";
  disabled = isPy27;
  inherit (libgumath) src version meta;

  checkInputs = [ numba ];
  propagatedBuildInputs = [ ndtypes xnd ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'add_include_dirs = [".", "libgumath", "ndtypes/python/ndtypes", "xnd/python/xnd"] + INCLUDES' \
                'add_include_dirs = [".", "${libndtypes}/include", "${libxnd}/include", "${libgumath}/include"]' \
      --replace 'add_library_dirs = ["libgumath", "ndtypes/libndtypes", "xnd/libxnd"] + LIBS' \
                'add_library_dirs = ["${libndtypes}/lib", "${libxnd}/lib", "${libgumath}/lib"]' \
      --replace 'add_runtime_library_dirs = ["$ORIGIN"]' \
                'add_runtime_library_dirs = ["${libndtypes}/lib", "${libxnd}/lib", "${libgumath}/lib"]'
  '';
}
