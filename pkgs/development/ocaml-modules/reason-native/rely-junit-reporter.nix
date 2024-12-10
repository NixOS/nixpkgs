{
  atdgen,
  junit,
  re,
  reason,
  pastel,
  rely,
  ...
}:

{
  pname = "rely-junit-reporter";

  nativeBuildInputs = [
    reason
  ];

  buildInputs = [
    atdgen
  ];

  propagatedBuildInputs = [
    junit
    re
    pastel
    rely
  ];

  meta = {
    description = "A tool providing JUnit Reporter for Rely Testing Framework";
    downloadPage = "https://github.com/reasonml/reason-native/tree/master/src/rely-junit-reporter";
    homepage = "https://reason-native.com/docs/rely/";
  };
}
