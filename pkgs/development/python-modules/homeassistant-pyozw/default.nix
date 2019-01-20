{ python_openzwave, fetchPypi }:

python_openzwave.overridePythonAttrs (oldAttrs: rec {
  pname = "homeassistant_pyozw";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "d64389f294b1fdee57adf78cd25ba45c9095facec3d80120182bbf8ba1fcdf05";
  };

  meta.homepage = https://github.com/home-assistant/python-openzwave;
})
