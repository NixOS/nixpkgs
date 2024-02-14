{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "openvr";
  version = "1.26.701";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kZ8whm9VZuKCgC8Al0GE0AU1FEb/bSJmR4kRmKh5mTE=";
  };


  meta = with lib; {
    homepage = "https://github.com/cmbruns/pyopenvr";
    description = "Unofficial python bindings for Valve's OpenVR virtual reality SDK";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}

