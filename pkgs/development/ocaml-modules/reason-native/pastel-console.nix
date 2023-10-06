{ reason, console, pastel, ... }:

{
  pname = "pastel-console";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    console
    pastel
  ];

  meta = {
    description = "Small library for pretty coloring to Console output";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/pastel-console";
    homepage = "https://reason-native.com/docs/pastel/console";
  };
}
