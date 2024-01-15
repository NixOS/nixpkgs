{ buildPythonPackage
, fetchFromGitHub
, lib
, pythonOlder
, pydal
, graphviz
, pandoc
, plantuml
}:

buildPythonPackage rec {
  pname = "pytm";
  version = "1.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "izar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bx4s9a5kdyr2xvpw0smmh7zi9w38891yfqzdj1bmnsjl57x6qrg";
  };

  propagatedBuildInputs = [ pydal graphviz pandoc plantuml ];

  pythonImportsCheck = [ "pytm" ];

  meta = with lib; {
    description = "A Pythonic framework for threat modeling";
    homepage = "https://owasp.org/www-project-pytm/";
    license = with licenses; [ capec mit ];
    maintainers = with maintainers; [ wamserma ];
  };
}
