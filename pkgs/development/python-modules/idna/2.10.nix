{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, isPy27
}:

buildPythonPackage rec {
  pname = "idna";
  version = "2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xmk3s92d2vq42684p61wixfmh3qpr2mw762w0n6662vhlpqf1xk";
  };

  checkInput = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
