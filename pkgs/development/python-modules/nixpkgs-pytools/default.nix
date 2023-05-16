{ lib
, buildPythonPackage
, fetchPypi
, jinja2
, setuptools
, rope
, isPy27
}:

buildPythonPackage rec {
  pname = "nixpkgs-pytools";
  version = "1.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11skcbi1lf9qcv9j5ikifb4pakhbbygqpcmv3390j7gxsa85cn19";
  };

  propagatedBuildInputs = [
    jinja2
    setuptools
    rope
  ];

  # tests require network ..
  doCheck = false;

  meta = with lib; {
    description = "Tools for removing the tedious nature of creating nixpkgs derivations";
    homepage = "https://github.com/nix-community/nixpkgs-pytools";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
