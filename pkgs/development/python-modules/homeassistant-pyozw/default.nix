{ python_openzwave, fetchPypi }:

python_openzwave.overridePythonAttrs (oldAttrs: rec {
  pname = "homeassistant_pyozw";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "136582d1b948168991af8ba1011304684834a4a61a6588e1c1f70b439b6f2483";
  };

  meta.homepage = https://github.com/home-assistant/python-openzwave;
})
