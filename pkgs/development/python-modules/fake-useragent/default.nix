{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "fake-useragent";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c104998b750eb097eefc28ae28e92d66397598d2cf41a31aa45d5559ef1adf35";
  };

  meta = with lib; {
    description = "Up to date simple useragent faker with real world database";
    homepage = https://github.com/hellysmile/fake-useragent;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
