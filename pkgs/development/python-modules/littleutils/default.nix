{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "littleutils";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vwijrylppmk0nbddqvn527r9cg3zw8d6zk6r58hslry42jf7jp6";
  };

  # This tiny package has no unit tests at all
  doCheck = false;
  pythonImportsCheck = [ "littleutils" ];

  meta = with lib; {
    description = "Small collection of Python utility functions";
    homepage = "https://github.com/alexmojaki/littleutils";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
