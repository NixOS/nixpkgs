{ python_openzwave, fetchPypi, openzwave, fetchFromGitHub }:

(python_openzwave.override {
  openzwave = openzwave.overrideAttrs (oldAttrs: {
    version = "unstable-2020-03-24";

    src = fetchFromGitHub {
      owner = "home-assistant";
      repo = "open-zwave";
      rev = "94267fa298c1882f0dc73c0fd08f1f755ba83e83";
      sha256 = "0p2869fwidz1wcqzfm52cwm9ab96pmwkna3d4yvvh21nh09cvmwk";
    };

    patches = [ ];
  });
}).overridePythonAttrs (oldAttrs: rec {
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
