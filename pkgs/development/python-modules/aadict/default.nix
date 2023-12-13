{ lib
, buildPythonPackage
, fetchPypi
, six
, nose
, coverage
}:

buildPythonPackage rec {
  pname = "aadict";
  version = "0.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "013pn9ii6mkql6khgdvsd1gi7zmya418fhclm5fp7dfvann2hwx7";
  };

  propagatedBuildInputs = [ six ];
  nativeCheckInputs = [ nose coverage ];

  meta = with lib; {
    homepage = "https://github.com/metagriffin/aadict";
    description = "An auto-attribute dict (and a couple of other useful dict functions).";
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl3;
  };
}
