{ python_openzwave, fetchPypi }:

python_openzwave.overridePythonAttrs (oldAttrs: rec {
  pname = "homeassistant_pyozw";
  version = "0.1.10";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "47c1abd8f3dc287760471c6c7b5fad222ead64763c4cb25e37d0599ea3b26952";
  };

  patches = [];
  meta.homepage = "https://github.com/home-assistant/python-openzwave";
})
