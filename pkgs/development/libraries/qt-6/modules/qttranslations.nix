{
  qtModule,
  qttools,
}:

qtModule {
  pname = "qttranslations";
  nativeBuildInputs = [ qttools ];
  outputs = [ "out" ];
}
