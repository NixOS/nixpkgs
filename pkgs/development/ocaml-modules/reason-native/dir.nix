{ reason, fp, ... }:

{
  pname = "dir";

  nativeBuildInputs = [
    reason
  ];

  propagatedBuildInputs = [
    fp
  ];

  meta = {
    description = "A library that provides a consistent API for common system, user and application directories consistently on all platforms";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/dir";
  };
}
