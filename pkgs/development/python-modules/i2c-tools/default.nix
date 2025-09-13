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

  meta = with lib; {
    inherit (i2c-tools.meta) homepage platforms;

    description = "Wrapper for i2c-tools' smbus stuff";
    # from py-smbus/smbusmodule.c
    license = [ licenses.gpl2Only ];
    maintainers = [ maintainers.evils ];
  };
}
