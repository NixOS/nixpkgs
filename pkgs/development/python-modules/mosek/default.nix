{
  autoPatchelfHook,
  buildPythonPackage,
  fetchurl,
  lib,
  numpy,
  onetbb,
  python,
  pythonOlder,
  setuptools,
  stdenv,
}:

buildPythonPackage (
  finalAttrs:
  let
    mosek-major-minor = lib.versions.majorMinor finalAttrs.version;
    python-major-version = python.sourceVersion.major;

    mosek-libs = stdenv.mkDerivation {
      pname = "mosek-libs";
      inherit (finalAttrs) version src;
      nativeBuildInputs = [
        onetbb
        autoPatchelfHook
      ];

      # Copy the vendor mosek library, which will optionally use a tbb that
      # is located next to it. We should use our own packaged one, even though
      # that is 2021.11.0 (libtbb.so.12.11) instead of the packaged 2021.12.0 (libtbb.so.12.12).
      # The packaged tbb would need to be patchelfed to find libstdc++ and would lead
      # with clashes with other code using the nix based tbb, used in rtech for example.
      installPhase = ''
        mkdir -p $out/lib
        cp ${mosek-major-minor}/tools/platform/linux64x86/bin/libmosek64.so.${mosek-major-minor} $out/lib/
        ln -snf ${onetbb}/lib/libtbb.so.12 $out/lib/libtbb.so.12
      '';
    };
  in
  {
    pname = "mosek";
    version = "11.2.2";
    pyproject = true;
    build-system = [ setuptools ];

    # MOSEK ships pre-built C extensions; minimum supported Python is 3.9
    disabled = pythonOlder "3.9";

    src = fetchurl {
      url = "https://download.mosek.com/stable/${finalAttrs.version}/mosektoolslinux64x86.tar.bz2";
      sha256 = "sha256-DVSZ+8ggmK7EyiaHYCUjxQ/3mY5GcUlgXVRfReiBkiw=";
    };

    # Move the source we want to the root
    prePatch = ''
      mv ${mosek-major-minor}/tools/platform/linux64x86/python/${python-major-version}/* .
    '';

    # Disable part of setup.py that 'fixes' library paths based on installation
    # location (which it gets wrong for a Nix build). Rely on autoPatchelfHook
    # instead. Also disable installation of _mskpreload.py, which tries to preload
    # dependent libraries and again gets the location wrong, and seems dangerous
    # anyway.
    postPatch = ''
      sed -i -e 's/^\(\s*\)#\?\(self.execute(self.install_\(libs\|preloader\),\)/\1#\2/' setup.py
    '';

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    propagatedBuildInputs = [
      mosek-libs
      numpy
    ];

    # No tests are supplied
    doCheck = false;

    pythonImportsCheck = [ "mosek" ];

    meta = with lib; {
      description = "Python interface for MOSEK - the package for large scale convex, conic and mixed-integer optimization.";
      homepage = "https://www.mosek.com/";
      changelog = "https://docs.mosek.com/${mosek-major-minor}/releasenotes/changes.html";
      license = licenses.unfree;
      maintainers = with maintainers; [ jherland ];
    };
  }
)
