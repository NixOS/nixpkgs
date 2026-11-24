{
  qtModule,
  python3,
  qttools,
}:

qtModule {
  pname = "qttranslations";
  nativeBuildInputs = [
    qttools
    # for translations/add_tika_to_ts.py, which generates the translations of
    # the mimetype database; cmake only warns when it is missing
    python3
  ];
  separateDebugInfo = false;
  outputs = [ "out" ];
  allowedReferences = [ "out" ];
}
