{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "appdirs";
  version = "1.4.4";

  src = fetchFromGitHub {
     owner = "ActiveState";
     repo = "appdirs";
     rev = "1.4.4";
     sha256 = "0d8hzhb1f1h16q1pxdx2h5xs6nmfjfjvkgqbb2rrsapj36r864za";
  };

  meta = {
    description = "A python module for determining appropriate platform-specific dirs";
    homepage = "https://github.com/ActiveState/appdirs";
    license = lib.licenses.mit;
  };
}
