{ python_openzwave, fetchPypi }:

python_openzwave.overridePythonAttrs (oldAttrs: rec {
  pname = "homeassistant_pyozw";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "a4ec26b95dba630df8c95c617c510e4a33db93a6a39e8a97056eec7dc9a49d1e";
  };

  meta.homepage = https://github.com/home-assistant/python-openzwave;
})
