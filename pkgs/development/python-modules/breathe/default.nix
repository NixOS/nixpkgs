{ lib, fetchFromGitHub, buildPythonPackage, docutils, six, sphinx, isPy3k, isPy27 }:

buildPythonPackage rec {
  version = "4.31.0";
  pname = "breathe";
  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "michaeljones";
     repo = "breathe";
     rev = "v4.31.0";
     sha256 = "0zziqfcap2s1h9apq60vlkzgqn7bawh79rnnkr5awyq8bgppwmdk";
  };

  propagatedBuildInputs = [ docutils six sphinx ];

  doCheck = !isPy3k;

  meta = {
    homepage = "https://github.com/michaeljones/breathe";
    license = lib.licenses.bsd3;
    description = "Sphinx Doxygen renderer";
    inherit (sphinx.meta) platforms;
  };
}

