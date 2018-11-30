{ stdenv
, buildPythonPackage
, pkgs
, numpy
, scipy
, enum34
, protobuf
, pip
, python
}:

buildPythonPackage rec {
  inherit (pkgs.cntk) name version src meta;

  buildInputs = [ pkgs.cntk pkgs.swig pkgs.openmpi ];
  propagatedBuildInputs = [ numpy scipy enum34 protobuf pip ];

  CNTK_LIB_PATH = "${pkgs.cntk}/lib";
  CNTK_COMPONENT_VERSION = pkgs.cntk.version;

  postPatch = ''
    cd bindings/python
    sed -i 's,"libmpi.so.12","${pkgs.openmpi}/lib/libmpi.so",g' cntk/train/distributed.py
  '';

  postInstall = ''
    rm -rf $out/${python.sitePackages}/cntk/libs
    ln -s ${pkgs.cntk}/lib $out/${python.sitePackages}/cntk/libs
    # It's not installed for some reason.
    cp cntk/cntk_py.py $out/${python.sitePackages}/cntk
  '';

  # Actual tests are broken.
  checkPhase = ''
    cd $NIX_BUILD_TOP
    ${python.interpreter} -c "import cntk"
  '';
}
