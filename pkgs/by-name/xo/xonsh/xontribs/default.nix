{
  callPackage,
}:
{
  xonsh-direnv = callPackage ./xonsh-direnv { };
  xontrib-abbrevs = callPackage ./xontrib-abbrevs { };
}
