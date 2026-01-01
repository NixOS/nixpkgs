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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (i2c-tools.meta) homepage platforms;

    description = "Wrapper for i2c-tools' smbus stuff";
    # from py-smbus/smbusmodule.c
<<<<<<< HEAD
    license = [ lib.licenses.gpl2Only ];
=======
    license = [ licenses.gpl2Only ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
