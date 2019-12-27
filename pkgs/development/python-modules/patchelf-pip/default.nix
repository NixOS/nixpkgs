{ stdenv
, python
, bootstrapped-pip
, patchelf
, manylinuxPackage
, patch
, src
, version
}:

stdenv.mkDerivation rec {
  inherit version src;
  pname = "pip";
  name = "${python.libPrefix}-${pname}-${version}";
  nativeBuildInputs = [ python bootstrapped-pip ];
  buildInputs = [ patchelf manylinuxPackage ];
  patches = [ patch ];
  postPatch = ''
      substituteInPlace src/pip/_internal/wheel.py \
        --subst-var-by PATCHELF_BIN '${patchelf}/bin/patchelf' \
        --subst-var-by NIX_MANYLILIB_PATH '${manylinuxPackage}/lib' \
        --subst-var-by DYNAMIC_LOADER "$(cat ${stdenv.cc.bintools}/nix-support/dynamic-linker)"
  '';
  buildPhase = ''
    export SOURCE_DATE_EPOCH=315532800
    python setup.py bdist_wheel
  '';
  installPhase = ''
    mkdir -p "$out"
    mv dist/pip-*.whl "$out"
  '';
  meta = {
    description = "The PyPA recommended tool for installing Python packages";
    license = stdenv.lib.licenses.mit;
    homepage = https://pip.pypa.io/;
  };
}
