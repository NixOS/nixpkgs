{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  pythonAtLeast,
  pyyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "j2cli";
  version = "0.3.10";
  disabled = pythonAtLeast "3.12";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "6f6f643b3fa5c0f72fbe9f07e246f8e138052b9f689e14c7c64d582c59709ae4";
  };

  build-system = [ setuptools ];
  dependencies = [
    jinja2
    pyyaml
  ];

  meta = {
    homepage = "https://github.com/kolypto/j2cli";
    description = "Jinja2 Command-Line Tool";
    mainProgram = "j2";
    license = lib.licenses.bsd2;
    longDescription = ''
      J2Cli is a command-line tool for templating in shell-scripts,
      leveraging the Jinja2 library.
    '';
    maintainers = with lib.maintainers; [
      rushmorem
      SuperSandro2000
    ];
  };
})
