args : with args; 
rec {
  src = fetchurl {
    url = http://www.saddi.com/software/flup/dist/flup-r2311.tar.gz;
    sha256 = "15wyn6d6wla1ag91yxmlh9b4m0w1i0c2lm8ka4qfv4ijqcqakdx3";
  };

  buildInputs = [python setuptools];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["addInputs" "createPythonInstallationTarget" (doDump "0") "installPythonPackage"];
      
  name = "flup-" + version;
  meta = {
    description = "FastCGI Python module set";
  };
}
