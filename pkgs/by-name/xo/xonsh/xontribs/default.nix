{
  callPackage,
}:
{
  xonsh-direnv = callPackage ./xonsh-direnv { };
  xontrib-abbrevs = callPackage ./xontrib-abbrevs { };
  xontrib-bashisms = callPackage ./xontrib-bashisms { };
  xontrib-debug-tools = callPackage ./xontrib-debug-tools { };
  xontrib-distributed = callPackage ./xontrib-distributed { };
  xontrib-fish-completer = callPackage ./xontrib-fish-completer { };
  xontrib-jedi = callPackage ./xontrib-jedi { };
  xontrib-jupyter = callPackage ./xontrib-jupyter { };
  xontrib-vox = callPackage ./xontrib-vox { };
  xontrib-whole-word-jumping = callPackage ./xontrib-whole-word-jumping { };
}
