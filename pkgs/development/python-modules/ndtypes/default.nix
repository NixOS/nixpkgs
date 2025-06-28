{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  numpy,
  libndtypes,
  isPy27,
}:

buildPythonPackage {
  pname = "ndtypes";
  format = "setuptools";
  disabled = isPy27;
  inherit (libndtypes) version src meta;

  outputs = [
    "out"
    "dev"
  ];

  propagatedBuildInputs = [ numpy ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'include_dirs = ["libndtypes"]' \
                'include_dirs = ["${libndtypes.dev}/include"]' \
      --replace-fail 'library_dirs = ["libndtypes"]' \
                'library_dirs = ["${libndtypes}/lib"]' \
      --replace-fail 'runtime_library_dirs = ["$ORIGIN"]' \
                'runtime_library_dirs = ["${libndtypes}/lib"]'
  '';

  postInstall = ''
    mkdir $out/include
    cp python/ndtypes/*.h $out/include
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath ${libndtypes}/lib $out/${python.sitePackages}/ndtypes/_ndtypes.*.so
  '';

  checkPhase = ''
    pushd python
    mv ndtypes _ndtypes
    python test_ndtypes.py
    popd
  '';
}
