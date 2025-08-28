{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "nine";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NSp9/hGVO39NEoqEeuAe50sdnfyVL4Lzyx8dvUHmbKk=";
  };

  build-system = [ poetry-core ];

  meta = with lib; {
    description = "Let's write Python 3 right now";
    homepage = "https://github.com/nandoflorestan/nine";
    license = licenses.free;
  };
}
