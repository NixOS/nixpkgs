{ reason, re, ... }:

{
  pname = "pastel";

  minimalOCamlVersion = "4.05";

  buildInputs = [
    reason
  ];
  propagatedBuildInputs = [
    re
  ];

  meta = {
    description = "A text formatting library that harnesses Reason JSX to provide intuitive terminal output. Like React but for CLI";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/pastel";
    homepage = "https://reason-native.com/docs/pastel/";
  };
}
