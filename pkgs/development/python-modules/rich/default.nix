{ lib, buildPythonPackage, fetchPypi, isPy27, typing-extensions, pygments, recommonmark, colorama }:

buildPythonPackage rec {
  pname = "rich";
  version = "8.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15yz7rcn5cjv233xcvka9vd573pwafl31s6z9ni54r8y4k926l0v";
  };

  propagatedBuildInputs = [ typing-extensions pygments recommonmark colorama ];

  doCheck = false;
  pythonImportsCheck = [ "rich" ];

  meta = with lib; {
    description = "Library for rich text and beautiful formatting in the terminal";
    homepage = "https://github.com/willmcgugan/rich";
    license = licenses.mit;
    maintainers = [ maintainers.sengaya ];
  };
}
