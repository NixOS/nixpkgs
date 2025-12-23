{
  qtModule,
  qttools,
}:

qtModule {
  pname = "qttranslations";
  nativeBuildInputs = [ qttools ];
  separateDebugInfo = false;
  outputs = [ "out" ];
  allowedReferences = [ "out" ];
}
