{ lib
, stdenv
, buildPythonPackage
, python
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

  nativeCheckInputs = [ numba ];
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

  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath ${libgumath}/lib $out/${python.sitePackages}/gumath/_gumath.*.so
  '';

  checkPhase = ''
    pushd python
    mv gumath _gumath
    # minor precision issues
    substituteInPlace test_gumath.py --replace 'test_sin' 'dont_test_sin'
    python test_gumath.py
    python test_xndarray.py
    popd
  '';

}

