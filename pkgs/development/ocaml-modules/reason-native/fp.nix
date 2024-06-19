{ reason, ... }:

{
  pname = "fp";

  nativeBuildInputs = [
    reason
  ];

  meta = {
    description = "Library for creating and operating on file paths consistently on multiple platforms";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/fp";
  };
}
