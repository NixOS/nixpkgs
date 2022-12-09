{ lib, buildPythonPackage, fetchPypi, six, random2 }:

buildPythonPackage rec {
  pname = "pysol-cards";
  version = "0.14.2";

  src = fetchPypi {
    inherit version;
    pname = "pysol_cards";
    sha256 = "sha256-wI3oV1d7w+7JcMOt08RbNlMWzChErNYIO7Vuox1A6vA=";
  };

  propagatedBuildInputs = [ six random2 ];

  meta = with lib; {
    description = "Generates Solitaire deals";
    homepage = "https://github.com/shlomif/pysol_cards";
    license = licenses.mit;
    maintainers = with maintainers; [ mwolfe ];
  };
}
