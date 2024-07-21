{
  lib,
  buildPythonPackage,
  i2c-tools,
}:

buildPythonPackage rec {
  inherit (i2c-tools) pname version src;

  format = "setuptools";

  buildInputs = [ i2c-tools ];

  preConfigure = "cd py-smbus";

  meta = with lib; {
    inherit (i2c-tools.meta) homepage platforms;

    description = "wrapper for i2c-tools' smbus stuff";
    # from py-smbus/smbusmodule.c
    license = [ licenses.gpl2Only ];
    maintainers = [ maintainers.evils ];
  };
}
