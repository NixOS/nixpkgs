{ lib, buildPythonPackage, fetchFromGitHub, sphinx, packaging }:

buildPythonPackage rec {
  pname = "pallets-sphinx-themes";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "pallets-sphinx-themes";
    rev = version;
    sha256 = "0nvznv6abmkkda2fahydd4rykd94rmz74hx5aypv6j22zvf5pj8b";
  };

  propagatedBuildInputs = [ packaging sphinx ];

  pythonImportsCheck = [ "pallets_sphinx_themes" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pallets/pallets-sphinx-themes";
    description = "Sphinx theme for Pallets projects";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
