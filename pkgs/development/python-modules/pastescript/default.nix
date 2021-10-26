{ lib
, buildPythonPackage
, fetchPypi
, nose
, six
, paste
, pastedeploy
}:

buildPythonPackage rec {
  pname = "pastescript";
  version = "3.2.1";

  src = fetchPypi {
    pname = "PasteScript";
    inherit version;
    sha256 = "f3ef819785e1b284e6fc108a131bce7e740b18255d96cd2e99ee3f00fd452468";
  };

  propagatedBuildInputs = [
    paste
    pastedeploy
    six
  ];

  checkInputs = [ nose ];

  pythonNamespaces = [ "paste" ];

  meta = with lib; {
    description = "A pluggable command-line frontend, including commands to setup package file layouts";
    homepage = "https://github.com/cdent/pastescript/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
