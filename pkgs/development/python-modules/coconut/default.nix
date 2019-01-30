{ lib
, buildPythonPackage
, fetchPypi
, prompt_toolkit
, pygments
, pyparsing
}:

buildPythonPackage rec {
  pname = "coconut";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b192c71022702b60b4c8c8dac06321a4a82e21c237ba2bb71d2edebb7540b8a9";
  };

  propagatedBuildInputs = [
    pygments
    prompt_toolkit
    pyparsing
  ];

  meta = with lib; {
    homepage = http://coconut-lang.org;
    license = licenses.asl20;
    description = "Simple, elegant, Pythonic functional programming";
    maintainers = with maintainers; [ bbarker ];
  };
}
