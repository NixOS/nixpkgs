{ stdenv, fetchPypi, buildPythonPackage, six, pytest }:

buildPythonPackage rec {
  pname = "fake-useragent";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dfz3bpmjmaxlhda6hfgsac7afb65pljibi8zkp9gc0ffn5rj161";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  meta = with stdenv.lib; {
    description = "Up to date simple useragent faker with real world database";
    homepage = "https://github.com/hellysmile/fake-useragent";
    license = licenses.asl20;
    maintainers = with maintainers; [ evanjs ];
  };
}
