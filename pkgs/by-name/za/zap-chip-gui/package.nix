{
  zap-chip,
  ...
}@args:

zap-chip.override (
  {
    withGui = true;
  }
  // removeAttrs args [ "zap-chip" ]
)
