{
  lib,
  buildPythonPackage,
  i2c-tools,
}:

buildPythonPackage {
  inherit (i2c-tools) pname version src;

  format = "setuptools";

  buildInputs = [ i2c-tools ];

  preConfigure = "cd py-smbus";

  # The version and src come from i2c-tools, nix-update on this package cannot update them
  passthru.updateScript = null;

  meta = {
    inherit (i2c-tools.meta) homepage platforms;

    description = "Wrapper for i2c-tools' smbus stuff";
    # from py-smbus/smbusmodule.c
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
