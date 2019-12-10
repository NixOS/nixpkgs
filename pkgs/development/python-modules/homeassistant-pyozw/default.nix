{ python_openzwave, fetchPypi }:

python_openzwave.overridePythonAttrs (oldAttrs: rec {
  pname = "homeassistant_pyozw";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "2d500638270ee4f0e7e9e114d9b4402c94c232f314116cdcf88d7c1dc9a44427";
  };

  meta.homepage = https://github.com/home-assistant/python-openzwave;
})
