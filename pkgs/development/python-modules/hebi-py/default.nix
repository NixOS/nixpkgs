{
  lib,
  python,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  patchelfUnstable,
  pyyaml,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "hebi-py";
  version = "2.7.9";
  pyproject = true;

  src = fetchPypi {
    pname = "hebi-py";
    inherit (finalAttrs) version;
    hash = "sha256-7B0oxG1CVDTUVDFTJpuYvaCj+HnCL/2zmsD33W4nTLs=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  build-system = [
    setuptools
    patchelfUnstable # Depends on --clear-execstack which is not in any tagged release yet
  ];
  dependencies = [
    numpy
    pyyaml
  ];

  doCheck = false; # no tests

  postFixup = ''
    for lib in $out/${python.sitePackages}/hebi/lib/linux_x86_64/libhebi.so*; do
      patchelf --clear-execstack "$lib"
    done
  '';

  pythonImportsCheck = [ "hebi" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library for the Hebi Robotics API";
    homepage = "https://docs.hebi.us/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
