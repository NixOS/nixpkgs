{ lib
, stdenv
, buildPythonPackage
, python
, numpy
, libndtypes
, isPy27
}:

buildPythonPackage {
  pname = "ndtypes";
  format = "setuptools";
  disabled = isPy27;
  inherit (libndtypes) version src meta;

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ numpy ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'include_dirs = ["libndtypes"]' \
                'include_dirs = ["${libndtypes.dev}/include"]' \
      --replace 'library_dirs = ["libndtypes"]' \
                'library_dirs = ["${libndtypes}/lib"]' \
      --replace 'runtime_library_dirs = ["$ORIGIN"]' \
                'runtime_library_dirs = ["${libndtypes}/lib"]'
  '';

  postInstall = ''
    mkdir $out/include
    cp python/ndtypes/*.h $out/include
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath ${libndtypes}/lib $out/${python.sitePackages}/ndtypes/_ndtypes.*.so
  '';

  checkPhase = ''
    pushd python
    mv ndtypes _ndtypes
    python test_ndtypes.py
    popd
  '';
}
