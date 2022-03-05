{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "imagesize";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd1750d452385ca327479d45b64d9c7729ecf0b3969a58148298c77092261f9d";
  };

  meta = with lib; {
    description = "Getting image size from png/jpeg/jpeg2000/gif file";
    homepage = "https://github.com/shibukawa/imagesize_py";
    license = with licenses; [ mit ];
  };

}
