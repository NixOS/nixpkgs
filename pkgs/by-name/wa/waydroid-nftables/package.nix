{
  waydroid,
  ...
}@args:

waydroid.override (
  {
    withNftables = true;
  }
  // removeAttrs args [ "waydroid" ]
)
