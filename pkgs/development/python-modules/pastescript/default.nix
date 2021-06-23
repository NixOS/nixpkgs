{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, paste
, PasteDeploy
, cheetah
}:

buildPythonPackage rec {
  version = "3.2.1";
  pname = "PasteScript";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f3ef819785e1b284e6fc108a131bce7e740b18255d96cd2e99ee3f00fd452468";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ six paste PasteDeploy cheetah ];

  doCheck = false;

  meta = with lib; {
    description = "A pluggable command-line frontend, including commands to setup package file layouts";
    homepage = "https://github.com/cdent/pastescript/";
    license = licenses.mit;
  };

}
