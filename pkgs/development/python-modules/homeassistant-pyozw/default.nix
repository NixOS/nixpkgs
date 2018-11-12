{ python_openzwave, fetchPypi }:

python_openzwave.overridePythonAttrs (oldAttrs: rec {
  pname = "homeassistant_pyozw";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "bca4062906f65db9b4668388e6755d6ea3ee9e1b02ad3ed81738bb4d32a79342";
  };

  meta.homepage = https://github.com/home-assistant/python-openzwave;
})
