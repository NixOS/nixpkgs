{
  lib,
  pkgs,
  stdenv,
  buildPythonPackage,
  foma,
  icu,
  swig,
}:

buildPythonPackage rec {
  pname = "hfst";
  format = "setuptools";
  inherit (pkgs.hfst) version src;

  sourceRoot = "${src.name}/python";

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version = '3.17.0_beta'" "version = '${version}'"

    # omorfi-python looks for 'hfst' Python package
    sed -i 's/libhfst_swig/hfst/' setup.py;
  '';

  nativeBuildInputs = [ swig ];

  buildInputs = [
    icu
    pkgs.hfst
  ];

  setupPyBuildFlags = [ "--inplace" ];

  # Find foma in Darwin tests
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${foma}/lib"
  '';

  meta = {
    description = "Python bindings for HFST";
    homepage = "https://github.com/hfst/hfst";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ lurkki ];
  };
}
