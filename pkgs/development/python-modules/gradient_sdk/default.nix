{ stdenv, fetchPypi, buildPythonPackage
, hyperopt
}:

buildPythonPackage rec {
  pname = "gradient_sdk";
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "Q9oeYjjgJf2lhxW1ypsweQAPpMglmW9PxgzMsgTqJkY=";
  };

  propagatedBuildInputs = [ hyperopt ];

  pythonImportsCheck = [ "gradient_sdk" ];

  meta = with stdenv.lib; {
    description = "Gradient ML SDK";
    homepage    = "https://github.com/Paperspace/gradient-sdk";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
