{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, requests
}:

buildPythonPackage rec {
  pname = "ebaysdk";
  version = "2.2.0";

  src = fetchFromGitHub {
     owner = "timotheus";
     repo = "ebaysdk-python";
     rev = "v2.2.0";
     sha256 = "1ym2qa0q89cd5agw07kkbzw0i5jyj1nm2zm58g94vjsg7acsbdkq";
  };

  propagatedBuildInputs = [
    lxml
    requests
  ];

  # requires network
  doCheck = false;

  meta = with lib; {
    description = "eBay SDK for Python";
    homepage = "https://github.com/timotheus/ebaysdk-python";
    license = licenses.cddl;
    maintainers = [ maintainers.mkg20001 ];
  };
}
