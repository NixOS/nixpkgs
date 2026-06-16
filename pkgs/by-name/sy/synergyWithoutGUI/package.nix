{
  synergy,
  ...
}@args:

synergy.override (
  {
    withGUI = false;
  }
  // removeAttrs args [ "synergy" ]
)
