{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  pythonAtLeast,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "j2cli";
  version = "0.3.10";
  format = "setuptools";
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6f6f643b3fa5c0f72fbe9f07e246f8e138052b9f689e14c7c64d582c59709ae4";
  };

  doCheck = false; # tests aren't installed thus aren't found, so skip
  propagatedBuildInputs = [
    jinja2
    pyyaml
    setuptools
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/kolypto/j2cli";
    description = "Jinja2 Command-Line Tool";
    mainProgram = "j2";
    license = lib.licenses.bsd2;
=======
  meta = with lib; {
    homepage = "https://github.com/kolypto/j2cli";
    description = "Jinja2 Command-Line Tool";
    mainProgram = "j2";
    license = licenses.bsd2;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    longDescription = ''
      J2Cli is a command-line tool for templating in shell-scripts,
      leveraging the Jinja2 library.
    '';
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      rushmorem
      SuperSandro2000
    ];
  };
}
