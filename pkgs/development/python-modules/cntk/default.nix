{ lib
, buildPythonPackage
, pkgs
, numpy
, scipy
, openmpi
, enum34
, protobuf
, pip
, python
, swig
}:

let
  cntk = pkgs.cntk;
in
buildPythonPackage {
  inherit (cntk) name version src;

  nativeBuildInputs = [ swig openmpi ];
  buildInputs = [ cntk openmpi ];
  propagatedBuildInputs = [ numpy scipy enum34 protobuf pip ];

  CNTK_LIB_PATH = "${cntk}/lib";
  CNTK_COMPONENT_VERSION = cntk.version;
  CNTK_VERSION = cntk.version;
  CNTK_VERSION_BANNER = cntk.version;

  postPatch = ''
    cd bindings/python
    sed -i 's,"libmpi.so.12","${openmpi}/lib/libmpi.so",g' cntk/train/distributed.py

    # Remove distro and libs checks; they aren't compatible with NixOS and besides we guarantee
    # compatibility by providing a package.
    cat <<EOF > cntk/cntk_py_init.py
    def cntk_check_distro_info():
      pass
    def cntk_check_libs():
      pass
    EOF
  '';

  postInstall = ''
    rm -rf $out/${python.sitePackages}/cntk/libs
    ln -s ${cntk}/lib $out/${python.sitePackages}/cntk/libs
    # It's not installed for some reason.
    cp cntk/cntk_py.py $out/${python.sitePackages}/cntk
  '';

  # Actual tests are broken.
  checkPhase = ''
    cd $NIX_BUILD_TOP
    ${python.interpreter} -c "import cntk"
  '';

  meta = {
    inherit (cntk.meta) homepage description license maintainers platforms;
    # doesn't support Python 3.7
    broken = lib.versionAtLeast python.version "3.7";
  };
}
