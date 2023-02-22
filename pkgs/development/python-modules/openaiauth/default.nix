{ buildPythonPackage, fetchPypi, setuptools, requests, lib }:

buildPythonPackage rec {
  pname = "OpenAIAuth";
  version = "0.3.2";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "CPcBgGvxRO677EdPI3lNtJXkCW7el6N6N2GeaDo5ApU=";
  };

  buildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "A Python library for authenticating with the OpenAI API.";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/acheong08/OpenAIAuth";
  };
}
