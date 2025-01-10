{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  random2,
}:

buildPythonPackage rec {
  pname = "pysol-cards";
  version = "0.18.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "pysol_cards";
    hash = "sha256-KRlurdUaVKe/hT0K7LoWiFOQOiSAO4VUcT6Mf8xzLCw=";
  };

  propagatedBuildInputs = [
    six
    random2
  ];

  meta = with lib; {
    description = "Generates Solitaire deals";
    mainProgram = "pysol_cards";
    homepage = "https://github.com/shlomif/pysol_cards";
    license = licenses.mit;
    maintainers = with maintainers; [ mwolfe ];
  };
}
